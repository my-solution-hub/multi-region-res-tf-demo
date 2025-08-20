#!/bin/bash

# Usage: ./scripts/destroy.sh <environment> <region> [profile]
# Example: ./scripts/destroy.sh dev us-east-1
# Example: ./scripts/destroy.sh dev cn-north-1 cn

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

if [ -n "$PROFILE" ]; then
    export AWS_PROFILE=$PROFILE
    # Clear AWS credential env vars to ensure profile is used
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    echo "Destroying $ENVIRONMENT environment in $REGION region using profile $PROFILE..."
else
    echo "Destroying $ENVIRONMENT environment in $REGION region..."
fi

echo "This will delete all resources. Are you sure? (y/N)"
read -r response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    terraform destroy \
        -var-file=regions/${REGION}/terraform.tfvars \
        -var-file=environments/${ENVIRONMENT}/terraform.tfvars \
        -auto-approve
else
    echo "Destroy cancelled."
fi
