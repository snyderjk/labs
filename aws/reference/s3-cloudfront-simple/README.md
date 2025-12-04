# S3 + CloudFront Static Website - Terraform Reference

This project demonstrates deploying a static website using AWS S3 and CloudFront CDN, fully managed with Terraform. This is part of a growing collection of AWS Infrastructure as Code projects that can be used as reference implementations for future work.

The implementation follows AWS best practices by using Origin Access Control (OAC) to keep the S3 bucket private, ensuring all traffic flows through the CloudFront distribution.

## Architecture

![Architecture Diagram](diagram/S3-CloudFront-Arch-Diagram.png)

### Components
- **S3 Bucket** - Private bucket storing static website files
- **CloudFront Distribution** - Global CDN for fast content delivery
- **Origin Access Control (OAC)** - AWS-recommended method for CloudFront-to-S3 authentication

### How it Works
1. User requests content via CloudFront domain URL
2. CloudFront checks edge location cache (1 hour TTL)
3. On cache miss, CloudFront authenticates to S3 using OAC and retrieves content
4. Content is cached and served to user

The S3 bucket remains fully private with all public access blocked, ensuring content is only accessible through the CloudFront distribution.

## Prerequisites

- Terraform >= v1.14
- AWS CLI v2 - configured with credentials for account that has access to manage S3, Cloudfront, and IAM resources
- S3 backend for Terraform state (configured in backend.tf)
  - S3 Bucket with versioning enabled
  - Dynamo table with 'LockID' partition key (String type)
  - See [Terraform S3 Backend Documentation](https://developer.hashicorp.com/terraform/language/backend/s3)

## Usage

### Configuration

1. **Clone the repository** to your local system

2. **Configure backend** (if using remote state):
   - Update `backend.tf` with your S3 bucket name and DynamoDB table name

3. **Review variables** in `variables.tf`:
   - `project_name` - Name for your project (used with AWS Account ID for unique S3 bucket name)
   - `content_path` - Path to website files (defaults to `./website/`)
   - `index_document` - Default page (default: `index.html`)
   - `error_document` - Error page (default: `error.html`)
   - `environment` - Environment tag (default: `dev`)

4. **Set required variables** in `terraform.tfvars`:
```hcl
   project_name = "your-project-name"
```
   You can override any other variables here as needed.

### Deployment
```bash
# Initialize Terraform (downloads providers, configures backend)
terraform init

# Preview changes
terraform plan

# Deploy infrastructure
terraform apply

# Clean up (note: S3 bucket must be empty first)
terraform destroy
```

**Note:** CloudFront distributions take 5-10 minutes to deploy.

### Accessing Your Site

After successful deployment, Terraform outputs the CloudFront domain:
```
domain = "d1234567890.cloudfront.net"
```

Navigate to this URL in your browser to view your site.

### Key Features
- Current recommended security with Origin Access Control instead of Origin Access Identity for CloudFront-to-S3 authentication
- Private S3 bucket for security, less of a attack surface for nefarious actors
- CloudFront CDN caching, faster site response time provided by edge locations
- Easy deployment, update, and destroy through Terraform deployment

### Future Enhancements
- HTTP Verbs limited to read-only website. May update variables to allow user to provide verbs needed
- After update, CloudFront still has cached content for TTL (1 hour), may need to provide option to invalidate CloudFront for time-sensitive deployments
- Add Route53 and ACM certificate resources for custom domains
- Expand support for multiple environments (dev/staging/prod) with separate state files

## Author

Jason Snyder - [GitHub](https://github.com/snyderjk) | [LinkedIn](https://linkedin.com/in/jason-devops)

Part of an AWS Infrastructure as Code Reference Project Repository
