#!/bin/bash

set -e

ENVIRONMENT=${1:-dev}
BUILD_NUMBER=${2:-latest}

echo "Deploying environment: $ENVIRONMENT with build: $BUILD_NUMBER"

cd "environments/$ENVIRONMENT"

terraform init

terraform validate

terraform plan -out=tfplan

terraform apply tfplan

CLUSTER_NAME=$(terraform output -raw ecs_cluster_name)
WEB_SERVICE=$(terraform output -raw web_app_service_name)
API_SERVICE=$(terraform output -raw admin_api_service_name)

echo "Updating ECS services..."

aws ecs update-service \
    --cluster $CLUSTER_NAME \
    --service $WEB_SERVICE \
    --force-new-deployment

aws ecs update-service \
    --cluster $CLUSTER_NAME \
    --service $API_SERVICE \
    --force-new-deployment

echo "Waiting for services to stabilize..."
aws ecs wait services-stable \
    --cluster $CLUSTER_NAME \
    --services $WEB_SERVICE $API_SERVICE

ALB_DNS=$(terraform output -raw alb_dns_name)
echo "Deployment completed successfully!"
echo "Application available at: http://$ALB_DNS"
