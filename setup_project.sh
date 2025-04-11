#!/bin/bash

# Project root
PROJECT_NAME="agentic-ai-workflow"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit

# Create top-level files
touch docker-compose.yml .env README.md

# Function to create FastAPI microservice with MVC
create_service() {
  SERVICE_NAME=$1
  mkdir -p "$SERVICE_NAME/app/controller" "$SERVICE_NAME/app/model" \
           "$SERVICE_NAME/app/services" "$SERVICE_NAME/app/agents"

  echo "from fastapi import FastAPI

app = FastAPI()

@app.get('/')
def root():
    return {'message': 'Hello from $SERVICE_NAME'}
" > "$SERVICE_NAME/app/main.py"

  echo "# Dockerfile for $SERVICE_NAME
FROM python:3.11

WORKDIR /app
COPY . /app

RUN pip install fastapi uvicorn

CMD [\"uvicorn\", \"app.main:app\", \"--host\", \"0.0.0.0\", \"--port\", \"8000\"]
" > "$SERVICE_NAME/Dockerfile"
}

# Gateway setup
mkdir -p gateway/app/routes gateway/app/services gateway/app/models gateway/app/utils
touch gateway/Dockerfile
echo "# Gateway main.py
from fastapi import FastAPI
from app.routes import nlp

app = FastAPI()

@app.get('/')
def root():
    return {'message': 'Gateway online'}
" > gateway/app/main.py

# Kafka setup
mkdir -p kafka/zookeeper kafka/kafka
touch kafka/docker-compose.kafka.yml

# Shared utils
mkdir -p shared/utils shared/configs
touch shared/base_agent.py

# Microservices
create_service "nlp_service"
create_service "vision_service"
create_service "audio_service"
create_service "rlhf_service"
create_service "gan_service"

# Audio special folders
mkdir -p audio_service/app/whisper audio_service/app/coqui_tts
touch audio_service/app/whisper/transcribe.py audio_service/app/coqui_tts/speak.py

# Database services
mkdir -p db_service/weaviate db_service/postgres db_service/redis

# Monitoring
mkdir -p monitoring/grafana monitoring/prometheus monitoring/logs

# Tests
mkdir -p tests/unit tests/integration tests/performance

echo "✅ Folder structure for '$PROJECT_NAME' created successfully."
