import boto3
import json
import os
from lib.response import success, failure


# function: initialization
def initialization():
    pass


# function: lambda invoker handler
def handler(event, context):
    status = 200
    if status == 200:
        response = success(json.dumps(event))
    else:
        response = failure(json.dumps(event))
    print(json.dumps(response))

    return response


# initialization, mapping
initialization()
