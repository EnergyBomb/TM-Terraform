import json
import boto3
import os

s3 = boto3.client('s3')
BUCKET_NAME = os.environ['S3_BUCKET']

def lambda_handler(event, context):
    try:
        file_content = event['body']
        file_name = event['headers']['filename']

        # Upload file to S3
        s3.put_object(Bucket=BUCKET_NAME, Key=file_name, Body=file_content)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'File uploaded successfully'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
            }