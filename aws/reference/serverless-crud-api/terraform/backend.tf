terraform {
  backend "s3" {
    bucket         = "snyderjk-terraform-state-files"
    key            = "projects/serverless-crud-api/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-statefile-locks"
    encrypt        = true
  }
}
