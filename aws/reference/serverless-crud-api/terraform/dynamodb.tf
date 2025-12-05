resource "aws_dynamodb_table" "items_table" {
  name         = "crud-api-items"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = local.common_tags

}
