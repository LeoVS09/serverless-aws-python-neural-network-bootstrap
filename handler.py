try:
    import unzip_requirements
except ImportError:
    pass

import json
from src.predict_answer import predict_answer as predict_answer_fn


"""Example function which using model for predict answer"""
def predict_answer(event, context):
    try:
        body = json.loads(event['body'])
        
        answer = predict_answer_fn(body['question'], body['context'])

        return {
            "statusCode": 200,
            "headers": {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                "Access-Control-Allow-Credentials": True

            },
            "body": json.dumps({'answer': answer})
        }
    
    except Exception as e:
        return {
            "statusCode": 500,
            "headers": {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                "Access-Control-Allow-Credentials": True
            },
            "body": json.dumps({"error": repr(e)})
        }
