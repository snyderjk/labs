import json
import urllib.parse

def lambda_handler(event, context):

    headers = {"Content-Type": "application/json"}

    try:
        record = event['Records'][0]
        bucket = record['s3']['bucket']['name']
        key = urllib.parse.unquote_plus(record['s3']['object']['key'], encoding='utf-8')
        event_name = record['eventName']

        print(f"Event: {event_name}")
        print(f"Bucket: {bucket}")
        print(f"File: {key}")
        print(f"Full Event: {json.dumps(event, indent=2)}")

        return {
            'statusCode': 200,
            'body': json.dumps(f"successfully processed {key}")
        }

    except Exception as e:
        print(f"Error processing S3 event: {str(e)}")
        raise



