import boto3
import config
import datetime

endpoint_url = {'Sandbox': 'https://mturk-requester-sandbox.us-east-1.amazonaws.com', 'Production': 'https://mturk-requester.us-east-1.amazonaws.com'}

client = boto3.client('mturk',
    aws_access_key_id=config.aws_access_key_id,
    aws_secret_access_key=config.aws_secret_access_key,
    region_name='us-east-1',
    endpoint_url=endpoint_url[config.stage])

hit = client.list_hits()['HITs'][0]

client.update_expiration_for_hit(HITId=hit['HITId'], ExpireAt=datetime.datetime(2015, 1, 1))
client.delete_hit(HITId=hit['HITId'])
