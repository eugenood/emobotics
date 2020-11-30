import boto3
import config

master_qualification = {'Sandbox': '2ARFPLSP75KLA8M8DH1HTEQVJT3SY6', 'Production': '2F1QJWKUDD8XADTFD2Q0G6UTO95ALH'}
endpoint_url = {'Sandbox': 'https://mturk-requester-sandbox.us-east-1.amazonaws.com', 'Production': 'https://mturk-requester.us-east-1.amazonaws.com'}

client = boto3.client('mturk',
    aws_access_key_id=config.aws_access_key_id,
    aws_secret_access_key=config.aws_secret_access_key,
    region_name='us-east-1',
    endpoint_url=endpoint_url[config.stage])

question = open('question.xml', 'r').read()

new_hit = client.create_hit(
    MaxAssignments=30,
    AutoApprovalDelayInSeconds=0,
    LifetimeInSeconds=36000,
    AssignmentDurationInSeconds=3600,
    Reward='2.85',
    Title='Research on Human-Robot Interaction',
    Keywords='hri, human, robotics, interaction',
    Description='In this HIT, you will be interacting with a virtual robot and answering some questions about your experience.',
    QualificationRequirements=[{'QualificationTypeId': master_qualification[config.stage], 'Comparator': 'Exists', 'RequiredToPreview': True}],
    Question=question
)

print("A new HIT has been created. You can preview it here:")

if config.stage == 'Sandbox':
    print("https://workersandbox.mturk.com/mturk/preview?groupId=" + new_hit['HIT']['HITGroupId'])

("HITID = " + new_hit['HIT']['HITId'] + " (Use to Get Results)")
