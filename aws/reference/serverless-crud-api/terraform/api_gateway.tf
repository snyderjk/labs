resource "aws_apigatewayv2_api" "crud_api" {
  name          = "crud-api"
  protocol_type = "HTTP"
  
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]
    allow_headers = ["*"]
  }
  
  tags = local.common_tags
}

resource "aws_apigatewayv2_integration" "create_item" {
  api_id           = aws_apigatewayv2_api.crud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.create_item_function.invoke_arn
}

resource "aws_apigatewayv2_route" "create_item" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "POST /items"
  target    = "integrations/${aws_apigatewayv2_integration.create_item.id}"
}

resource "aws_lambda_permission" "create_item_apigw" {
  statement_id  = "AllowAPIGatewayInvoke_create"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_item_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.crud_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "read_item" {
  api_id           = aws_apigatewayv2_api.crud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.read_item_function.invoke_arn
}

resource "aws_apigatewayv2_route" "read_item" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.read_item.id}"
}

resource "aws_lambda_permission" "read_item_apigw" {
  statement_id  = "AllowAPIGatewayInvoke_read"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read_item_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.crud_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "update_item" {
  api_id           = aws_apigatewayv2_api.crud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.update_item_function.invoke_arn
}

resource "aws_apigatewayv2_route" "update_item" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "PUT /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.update_item.id}"
}

resource "aws_lambda_permission" "update_item_apigw" {
  statement_id  = "AllowAPIGatewayInvoke_update"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_item_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.crud_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "patch_item" {
  api_id           = aws_apigatewayv2_api.crud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.patch_item_function.invoke_arn
}

resource "aws_apigatewayv2_route" "patch_item" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "PATCH /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.patch_item.id}"
}

resource "aws_lambda_permission" "patch_item_apigw" {
  statement_id  = "AllowAPIGatewayInvoke_patch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.patch_item_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.crud_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "delete_item" {
  api_id           = aws_apigatewayv2_api.crud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.delete_item_function.invoke_arn
}

resource "aws_apigatewayv2_route" "delete_item" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "DELETE /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.delete_item.id}"
}

resource "aws_lambda_permission" "delete_item_apigw" {
  statement_id  = "AllowAPIGatewayInvoke_delete"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_item_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.crud_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "list_items" {
  api_id           = aws_apigatewayv2_api.crud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.list_items_function.invoke_arn
}

resource "aws_apigatewayv2_route" "list_items" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.list_items.id}"
}

resource "aws_lambda_permission" "list_items_apigw" {
  statement_id  = "AllowAPIGatewayInvoke_list"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_items_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.crud_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.crud_api.id
  name        = "$default"
  auto_deploy = true
  
  tags = local.common_tags
}
