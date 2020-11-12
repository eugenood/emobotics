import boto3
import config

client = boto3.client('mturk',
    aws_access_key_id=config.aws_access_key_id,
    aws_secret_access_key=config.aws_secret_access_key,
    region_name='us-east-1',
    endpoint_url='https://mturk-requester-sandbox.us-east-1.amazonaws.com')

question = open('question.xml', 'r').read()

new_hit = client.create_hit(
    MaxAssignments=200,
    AutoApprovalDelayInSeconds=36000,
    LifetimeInSeconds=36000,
    AssignmentDurationInSeconds=3600,
    Reward='0.01',
    Title='Emotion and Robotics',
    Keywords='emotion, robotics',
    Description='Play with an emotional robot',
    Question=question
)

print("A new HIT has been created. You can preview it here:")
print("https://workersandbox.mturk.com/mturk/preview?groupId=" + new_hit['HIT']['HITGroupId'])
print("HITID = " + new_hit['HIT']['HITId'] + " (Use to Get Results)")
