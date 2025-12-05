import os
import json
import boto3
from datetime import datetime, timezone

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
        request = json.loads(event['body'])

        if 'pathParameters' not in event or 'id' not in event['pathParameters']:
            return {
                "statusCode": 400,
                "headers": headers,
                "body": json.dumps({"error": "Missing required path parameter: id"})
            }

        if "name" not in request:
            return {
                "statusCode": 400,
                "headers": headers,
                "body": json.dumps({"error": "Missing required field: name"})
            }

        item_id = event['pathParameters']['id']

        response = table.get_item(Key={"id": item_id})

        if "Item" not in response:
            return {
                "statusCode": 404,
                "headers": headers,
                "body": json.dumps({"error": "Item not found"})
            }

        original_created_date = response["Item"]["created_at"]

        timestamp = datetime.now(timezone.utc).isoformat() + 'Z'
        item = {
            "id": item_id,
            "name": request["name"],
            "description": request.get("description", ""),
            "status": request.get("status", "active"),
            "metadata": request.get("metadata", {}),
            "created_at": original_created_date,
            "updated_at": timestamp
        }

        table.put_item(Item=item)

        headers["Access-Control-Allow-Origin"] = "*"
        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({
                "message": "Item updated successfully",
                "data": item
            })
        }
    except json.JSONDecodeError:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"error": "Invalid JSON in request body"})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"error": str(e)})
        }



