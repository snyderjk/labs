output "domain" {
  description = "Access Url"
  value       = aws_cloudfront_distribution.site_cf_distribution.domain_name
}

output "bucket" {
  description = "Bucket with site contents"
  value       = aws_s3_bucket.site_bucket.id
}

output "distribution_id" {
  description = "Cloudfront distribution id"
  value       = aws_cloudfront_distribution.site_cf_distribution.id
}
