variable "project_name" {
  description = "Project Name"
  type        = string
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

variable "lambda_function_name" {
  description = "Name of the Lambda function that processes S3 events"
  type        = string
  default     = "s3-event-processor"
}
