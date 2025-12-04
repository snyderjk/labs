data "aws_caller_identity" "current" {}

locals {
  # Get current AWS account ID for unique bucket naming
  account_id   = data.aws_caller_identity.current.account_id
  s3_origin_id = "S3-${var.project_name}"

  # Tags applied to all resources for organization and cost tracking
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  # MIME type mappig for proper content serving
  mime_types = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".json" = "application/json"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
  }
}

resource "aws_s3_bucket" "site_bucket" {
  bucket = "${var.project_name}-${local.account_id}"

  tags = local.common_tags
}

resource "aws_s3_bucket_website_configuration" "bucket_website_config" {
  bucket = aws_s3_bucket.site_bucket.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

# Bucket will not be publicly accessible, only through CloudFront
resource "aws_s3_bucket_public_access_block" "bucket_public_access_config" {
  bucket = aws_s3_bucket.site_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "site_contents" {
  for_each = fileset(var.content_path, "**/*")

  bucket       = aws_s3_bucket.site_bucket.id
  key          = each.value
  source       = "${var.content_path}/${each.value}"
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")
  etag         = filemd5("${var.content_path}/${each.value}")

  tags = local.common_tags
}


# Using OAC instead of OAI (AWS best practice as of 2023)
# Keeps S3 bucket private while allowing CloudFront access
resource "aws_cloudfront_origin_access_control" "bucket_oac" {
  name                              = "${var.project_name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# This is a view only website with no interaction
# verbs may need to be changed depending on site
resource "aws_cloudfront_distribution" "site_cf_distribution" {
  enabled             = true
  default_root_object = var.index_document

  origin {
    domain_name              = aws_s3_bucket.site_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.bucket_oac.id
    origin_id                = local.s3_origin_id
  }

  default_cache_behavior {
    allowed_methods  = ["HEAD", "OPTIONS", "GET"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = local.common_tags
}

# Bucket policy grants CloudFront distribuion exclusive access to the S3 bucket
# Prevents direct S3 access - all traffic must flow through Cloudfront CDN
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.site_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.site_cf_distribution.arn
          }
        }
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.site_bucket.arn}/*"
        ]
      }
    ]
  })
}
