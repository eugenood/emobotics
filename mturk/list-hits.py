import boto3
import config
import datetime

endpoint_url = {'Sandbox': 'https://mturk-requester-sandbox.us-east-1.amazonaws.com', 'Production': 'https://mturk-requester.us-east-1.amazonaws.com'}

client = boto3.client('mturk',
    aws_access_key_id=config.aws_access_key_id,
    aws_secret_access_key=config.aws_secret_access_key,
    region_name='us-east-1',
    endpoint_url=endpoint_url[config.stage])

for hit in client.list_hits()['HITs']:
    print(hit)
    print()
