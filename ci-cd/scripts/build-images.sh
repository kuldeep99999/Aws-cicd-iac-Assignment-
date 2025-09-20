#!/bin/bash

set -e

ENVIRONMENT=${1:-dev}
BUILD_NUMBER=${2:-latest}
AWS_REGION=${AWS_DEFAULT_REGION:-ap-south-1}

echo "Building and pushing images for environment: $ENVIRONMENT"

# Get AWS Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY

# Build and push web app image
echo "Building web app image..."
docker build -t microservices-web-app:$BUILD_NUMBER ./ci-cd/docker/web-app/
docker tag microservices-web-app:$BUILD_NUMBER $ECR_REGISTRY/microservices-web-app:$BUILD_NUMBER
docker tag microservices-web-app:$BUILD_NUMBER $ECR_REGISTRY/microservices-web-app:latest

echo "Pushing web app image..."
docker push $ECR_REGISTRY/microservices-web-app:$BUILD_NUMBER
docker push $ECR_REGISTRY/microservices-web-app:latest

# Build and push admin API image
echo "Building admin API image..."
docker build -t microservices-admin-api:$BUILD_NUMBER ./ci-cd/docker/admin-api/
docker tag microservices-admin-api:$BUILD_NUMBER $ECR_REGISTRY/microservices-admin-api:$BUILD_NUMBER
docker tag microservices-admin-api:$BUILD_NUMBER $ECR_REGISTRY/microservices-admin-api:latest

echo "Pushing admin API image..."
docker push $ECR_REGISTRY/microservices-admin-api:$BUILD_NUMBER
docker push $ECR_REGISTRY/microservices-admin-api:latest

echo "Images built and pushed successfully!"
