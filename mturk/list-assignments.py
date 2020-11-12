import boto3
import config
import datetime
import sys

client = boto3.client('mturk',
    aws_access_key_id=config.aws_access_key_id,
    aws_secret_access_key=config.aws_secret_access_key,
    region_name='us-east-1',
    endpoint_url='https://mturk-requester-sandbox.us-east-1.amazonaws.com')

print(client.list_assignments_for_hit(HITId=sys.argv[1]))
