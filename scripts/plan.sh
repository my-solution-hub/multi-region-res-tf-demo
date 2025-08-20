#!/bin/bash

# Usage: ./scripts/plan.sh <environment> <region> [profile]
# Example: ./scripts/plan.sh dev us-east-1
# Example: ./scripts/plan.sh dev cn-north-1 cn

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "Usage: $0 <environment> <region> [profile]"
    echo "Example: $0 dev us-east-1"
    echo "Example: $0 dev cn-north-1 cn"
    exit 1
fi

ENVIRONMENT=$1
REGION=$2
PROFILE=$3

export TF_VAR_environment=$ENVIRONMENT
export TF_VAR_region=$REGION
export TF_VAR_aws_region=$REGION

if [ -n "$PROFILE" ]; then
    export AWS_PROFILE=$PROFILE
    # Clear AWS credential env vars to ensure profile is used
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    echo "Planning deployment for $ENVIRONMENT environment in $REGION region using profile $PROFILE..."
else
    echo "Planning deployment for $ENVIRONMENT environment in $REGION region..."
fi

# Initialize with correct backend
./scripts/init.sh $REGION $PROFILE

terraform plan \
    -var-file=regions/${REGION}/terraform.tfvars \
    -var-file=environments/${ENVIRONMENT}/terraform.tfvars
