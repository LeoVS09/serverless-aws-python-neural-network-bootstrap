import json
import boto3


"""Example simple function"""
def hello(event, context):
    body = {
        "message": "Go Serverless v1.0! Your function executed successfully!",
        "input": event
    }

    response = {
        "statusCode": 200,
        "body": json.dumps(body)
    }

    return response

    # Use this code if you don't use the http event with the LAMBDA-PROXY
    # integration
    """
    return {
        "message": "Go Serverless v1.0! Your function executed successfully!",
        "event": event
    }
    """

"""Example of S3 model class"""
class MyModel(object):
    def __init__(self, name, value):
        self.name = name
        self.value = value

    def save(self):
        s3 = boto3.client('s3', region_name='eu-central-1')
        s3.put_object(Bucket='python-botstrap-example-bucket', Key=self.name, Body=self.value)

""" Example function which using S3"""
def save_s3_model(event, context):

    model = MyModel(**event)
    model.save()