data "archive_file" "create_item_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/create_item/"
  output_path = "${path.module}/../lambda/zips/create_item.zip"
}

data "archive_file" "read_item_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/read_item/"
  output_path = "${path.module}/../lambda/zips/read_item.zip"
}

data "archive_file" "update_item_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/update_item/"
  output_path = "${path.module}/../lambda/zips/update_item.zip"
}

data "archive_file" "patch_item_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/patch_item/"
  output_path = "${path.module}/../lambda/zips/patch_item.zip"
}

data "archive_file" "delete_item_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/delete_item/"
  output_path = "${path.module}/../lambda/zips/delete_item.zip"
}

data "archive_file" "list_items_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/list_items/"
  output_path = "${path.module}/../lambda/zips/list_items.zip"
}

resource "aws_lambda_function" "create_item_function" {
  filename         = data.archive_file.create_item_zip.output_path
  function_name    = "crud-api-create-item"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.create_item_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.items_table.name
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_function" "read_item_function" {
  filename         = data.archive_file.read_item_zip.output_path
  function_name    = "crud-api-read-item"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.read_item_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.items_table.name
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_function" "update_item_function" {
  filename         = data.archive_file.update_item_zip.output_path
  function_name    = "crud-api-update-item"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.update_item_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.items_table.name
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_function" "patch_item_function" {
  filename         = data.archive_file.patch_item_zip.output_path
  function_name    = "crud-api-patch-item"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.patch_item_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.items_table.name
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_function" "delete_item_function" {
  filename         = data.archive_file.delete_item_zip.output_path
  function_name    = "crud-api-delete-item"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.delete_item_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.items_table.name
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_function" "list_items_function" {
  filename         = data.archive_file.list_items_zip.output_path
  function_name    = "crud-api-list-items"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.list_items_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.items_table.name
    }
  }

  tags = local.common_tags
}
