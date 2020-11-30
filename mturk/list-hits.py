import boto3
import config
import datetime

client = boto3.client('mturk',
    aws_access_key_id=config.aws_access_key_id,
    aws_secret_access_key=config.aws_secret_access_key,
    region_name='us-east-1',
    endpoint_url=endpoint_url[config.stage])

print(client.list_hits())
