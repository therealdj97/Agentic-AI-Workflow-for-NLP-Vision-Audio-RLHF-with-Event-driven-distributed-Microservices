# Gateway main.py
from fastapi import FastAPI
from app.routes import nlp

app = FastAPI()

@app.get('/')
def root():
    return {'message': 'Gateway online'}

