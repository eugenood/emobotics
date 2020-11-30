import boto3
import config
import datetime
import sys
import xmltodict

endpoint_url = {'Sandbox': 'https://mturk-requester-sandbox.us-east-1.amazonaws.com', 'Production': 'https://mturk-requester.us-east-1.amazonaws.com'}

client = boto3.client('mturk',
    aws_access_key_id=config.aws_access_key_id,
    aws_secret_access_key=config.aws_secret_access_key,
    region_name='us-east-1',
    endpoint_url=endpoint_url[config.stage])

hits = ['3S8APUMBK4KS7CPZ9JS88WVPG9XFB3', '3VDI8GSXBMUFJENNHREGZF509IBG83', '3W9XHF7WHRW3JKBUAGAQO3TGUCFTKA', '3ZFRE2BDRGF5PWJ0FREX0L2ZBHGXZJ']

if not hits:
    hits = [sys.argv[1]]

csv_output = ''

for hit in hits:
    assignments = client.list_assignments_for_hit(HITId=hit)['Assignments']
    for assignment in assignments:
        answers = xmltodict.parse(assignment['Answer'])['QuestionFormAnswers']['Answer']
        if not csv_output:
            csv_output += 'de_assignmentid,de_workerid,de_hitid,'
            for answer in answers[:-1]:
                csv_output += answer['QuestionIdentifier'] + ','
            csv_output += answers[-1]['QuestionIdentifier'] + '\n'
        csv_output += assignment['AssignmentId'] + ','
        csv_output += assignment['WorkerId'] + ','
        csv_output += assignment['HITId'] + ','
        for answer in answers[:-1]:
            if answer['FreeText']:
                csv_output += answer['FreeText'].replace(',', ';').replace('\n', ' ').replace('\r', '') + ','
            else:
                csv_output += ','
        csv_output += answers[-1]['FreeText'] + '\n'

print(csv_output)
