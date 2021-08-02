
from .S3Model import S3Model

model = S3Model('./model', 'neural-networks-model-example', 'squad-distilbert/en.tar.gz')

def predict_answer(question, context):
    answer = model.predict(question, context)
    return answer
   