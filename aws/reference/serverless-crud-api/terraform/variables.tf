variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Environment for the deployed resources"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be in dev, staging, or prod"
  }
}
