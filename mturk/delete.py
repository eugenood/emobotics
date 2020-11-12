import boto3
import config
import datetime

client = boto3.client('mturk',
    aws_access_key_id=config.aws_access_key_id,
    aws_secret_access_key=config.aws_secret_access_key,
    region_name='us-east-1',
    endpoint_url='https://mturk-requester-sandbox.us-east-1.amazonaws.com')

for hit in client.list_hits()['HITs']:
    # client.update_expiration_for_hit(HITId=hit['HITId'], ExpireAt=datetime.datetime(2015, 1, 1))
    client.delete_hit(HITId=hit['HITId'])
