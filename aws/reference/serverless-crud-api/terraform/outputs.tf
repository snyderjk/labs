output "api_gateway_url" {
  description = "Base URL for API Gateway"
  value       = aws_apigatewayv2_api.crud_api.api_endpoint
}

output "api_gateway_invoke_url" {
  description = "Full invoke URL for API Gateway"
  value       = "${aws_apigatewayv2_api.crud_api.api_endpoint}/items"
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.items_table.name
}

output "lambda_function_names" {
  description = "Names of all Lambda functions"
  value = {
    create = aws_lambda_function.create_item_function.function_name
    read   = aws_lambda_function.read_item_function.function_name
    update = aws_lambda_function.update_item_function.function_name
    patch  = aws_lambda_function.patch_item_function.function_name
    delete = aws_lambda_function.delete_item_function.function_name
    list   = aws_lambda_function.list_items_function.function_name
  }
}

output "api_endpoints" {
  description = "API endpoint URLs"
  value = {
    base_url    = aws_apigatewayv2_api.crud_api.api_endpoint
    create_item = "${aws_apigatewayv2_api.crud_api.api_endpoint}/items"
    list_items  = "${aws_apigatewayv2_api.crud_api.api_endpoint}/items"
    read_item   = "${aws_apigatewayv2_api.crud_api.api_endpoint}/items/{id}"
    update_item = "${aws_apigatewayv2_api.crud_api.api_endpoint}/items/{id}"
    patch_item  = "${aws_apigatewayv2_api.crud_api.api_endpoint}/items/{id}"
    delete_item = "${aws_apigatewayv2_api.crud_api.api_endpoint}/items/{id}"
  }
}
