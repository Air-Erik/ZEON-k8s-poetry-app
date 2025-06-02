#!/bin/bash

# Сборка Docker образа
docker build -t python-db-app:latest .

# Применение манифестов Kubernetes
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/deployment.yaml

# Проверка статуса развертывания
echo "Waiting for deployment to complete..."
kubectl rollout status deployment/python-db-app
