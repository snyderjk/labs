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

        result = table.scan()

        headers["Access-Control-Allow-Origin"] = "*"
        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({"data": result["Items"], "count": len(result["Items"])})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"error": str(e)})
        }

