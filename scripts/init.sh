#!/bin/bash

# Usage: ./scripts/init.sh [region] [profile]
# Example: ./scripts/init.sh us-east-1
# Example: ./scripts/init.sh cn-north-1 cn

REGION=$1
PROFILE=$2

if [ -n "$PROFILE" ]; then
    export AWS_PROFILE=$PROFILE
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
fi

if [[ "$REGION" == cn-* ]]; then
    echo "Initializing Terraform with China backend..."
    terraform init -backend-config=backend-configs/china.hcl
else
    echo "Initializing Terraform with global backend..."
    terraform init -backend-config=backend-configs/global.hcl
fi
