from fastapi import FastAPI

app = FastAPI()

@app.get('/')
def root():
    return {'message': 'Hello from nlp_service'}

