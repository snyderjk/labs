import os
import json
import boto3
from datetime import datetime, timezone

table_name = os.environ.get("TABLE_NAME", "")
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(table_name) # type: ignore

def lambda_handler(event, context):

    headers = {"Content-Type": "application/json"}
    update_parts = []
    attr_names = {}
    attr_values = {}

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

        item_id = event['pathParameters']['id']
        
        update_patch_request_with_field("name", request, update_parts, attr_names, attr_values)
        update_patch_request_with_field("description", request, update_parts, attr_names, attr_values)
        update_patch_request_with_field("status", request, update_parts, attr_names, attr_values)
        update_patch_request_with_field("metadata", request, update_parts, attr_names, attr_values)
        timestamp = datetime.now(timezone.utc).isoformat() + 'Z'
        update_patch_request_with_value("updated_at", timestamp, update_parts, attr_names, attr_values)

        if len(update_parts) == 1:
            return {
                "statusCode": 400,
                "headers": headers,
                "body": json.dumps({"error": "No fields to update"})
            }

        response = table.update_item(
            Key={"id": item_id},
            UpdateExpression=f"SET {', '.join(update_parts)}",
            ExpressionAttributeNames=attr_names,
            ExpressionAttributeValues=attr_values,
            ReturnValues='ALL_NEW'
        )
        
        updated_item = response['Attributes']

        headers["Access-Control-Allow-Origin"] = "*"
        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({
                "message": "Item updated successfully",
                "data": updated_item
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

def update_patch_request_with_field(field, request, update_parts, attr_names, attr_values):
    if field in request: 
        update_parts.append(f"#{field} = :{field}")
        attr_names[f"#{field}"] = field
        attr_values[f":{field}"] = request[field]

def update_patch_request_with_value(field, value, update_parts, attr_names, attr_values):
        update_parts.append(f"#{field} = :{field}")
        attr_names[f"#{field}"] = field
        attr_values[f":{field}"] = value



