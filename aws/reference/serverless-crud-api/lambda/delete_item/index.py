import os
import json
import boto3

table_name = os.environ.get("TABLE_NAME", "")
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(table_name) # type: ignore

def lambda_handler(event, context):
    headers = {"Content-Type": "application/json"}

    if table_name == "":
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"error": "DynamoDB table name not set in environment variables"})
        }

    try:
        headers["Access-Control-Allow-Origin"] = "*"

        if 'pathParameters' not in event or 'id' not in event['pathParameters']:
            return {
                "statusCode": 400,
                "headers": headers,
                "body": json.dumps({"error": "Missing required path parameter: id"})
            }

        item_id = event['pathParameters']['id']

        table.delete_item(Key={"id": item_id})

        return {
            "statusCode": 204,
            "headers": headers
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"error": str(e)})
        }



