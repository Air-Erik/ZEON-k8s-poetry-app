# Создание namespace если его нет
Write-Host "Creating namespace if it doesn't exist..."
kubectl create namespace test-app --dry-run=client -o yaml | kubectl apply -f -

# Сборка Docker образа
Write-Host "Building Docker image..."
docker build -t python-db-app:latest .

# Применение манифестов Kubernetes
Write-Host "Applying Kubernetes manifests..."
kubectl apply -f k8s/secrets.yaml -n test-app
kubectl apply -f k8s/deployment.yaml -n test-app

# Проверка статуса развертывания
Write-Host "Waiting for deployment to complete..."
kubectl rollout status deployment/python-db-app -n test-app
