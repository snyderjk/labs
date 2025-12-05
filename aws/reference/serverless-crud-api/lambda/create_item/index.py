import os
import json
import boto3
import uuid
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

        if "name" not in request:
            return {
                "statusCode": 400,
                "headers": headers,
                "body": json.dumps({"error": "Missing required field: name"})
            }

        timestamp = datetime.now(timezone.utc).isoformat() + 'Z'
        item = {
            "id": str(uuid.uuid4()),
            "name": request["name"],
            "description": request.get("description", ""),
            "status": request.get("status", "active"),
            "metadata": request.get("metadata", {}),
            "created_at": timestamp,
            "updated_at": timestamp
        }

        table.put_item(Item=item)

        headers["Access-Control-Allow-Origin"] = "*"
        return {
            "statusCode": 201,
            "headers": headers,
            "body": json.dumps({
                "message": "Item created successfully",
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



