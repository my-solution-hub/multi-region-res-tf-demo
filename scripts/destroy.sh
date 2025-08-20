#!/bin/bash

# Usage: ./scripts/destroy.sh <environment> <region>
# Example: ./scripts/destroy.sh dev us-east-1

if [ $# -ne 2 ]; then
    echo "Usage: $0 <environment> <region>"
    echo "Example: $0 dev us-east-1"
    exit 1
fi

ENVIRONMENT=$1
REGION=$2

export TF_VAR_environment=$ENVIRONMENT
export TF_VAR_region=$REGION

echo "Destroying $ENVIRONMENT environment in $REGION region..."
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
