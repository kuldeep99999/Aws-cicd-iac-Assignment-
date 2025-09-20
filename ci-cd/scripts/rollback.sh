#!/bin/bash

set -e

ENVIRONMENT=${1:-dev}
PREVIOUS_BUILD=${2}

if [ -z "$PREVIOUS_BUILD" ]; then
    echo "Usage: $0 <environment> <previous_build_number>"
    exit 1
fi

echo "Rolling back to build: $PREVIOUS_BUILD"

aws ecs update-service \
    --cluster microservices-cluster \
    --service microservices-web-app \
    --task-definition microservices-web-app:$PREVIOUS_BUILD

aws ecs update-service \
    --cluster microservices-cluster \
    --service microservices-admin-api \
    --task-definition microservices-admin-api:$PREVIOUS_BUILD

aws ecs wait services-stable \
    --cluster microservices-cluster \
    --services microservices-web-app microservices-admin-api

echo "Rollback completed successfully"
