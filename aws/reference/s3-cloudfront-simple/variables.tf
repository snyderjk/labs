variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "content_path" {
  description = "Path to contents to be uploaded to S3 bucket"
  type        = string
  default     = "./website/"
}

variable "index_document" {
  description = "Default page for the S3 site"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Custom error page for S3 site"
  type        = string
  default     = "error.html"
}

variable "environment" {
  description = "environment for the deployed resources"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be in dev, staging, or prod"
  }
}

