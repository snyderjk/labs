output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.bucket.id
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.lambda_function.function_name
}

output "cloudwatch_log_group" {
  description = "CloudWatch Log Group for Lambda"
  value       = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
}
