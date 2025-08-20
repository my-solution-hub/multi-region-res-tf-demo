#!/bin/bash

# Usage: ./scripts/plan.sh <environment> <region>
# Example: ./scripts/plan.sh dev us-east-1

if [ $# -ne 2 ]; then
    echo "Usage: $0 <environment> <region>"
    echo "Example: $0 dev us-east-1"
    exit 1
fi

ENVIRONMENT=$1
REGION=$2

export TF_VAR_environment=$ENVIRONMENT
export TF_VAR_region=$REGION

echo "Planning deployment for $ENVIRONMENT environment in $REGION region..."

terraform plan \
    -var-file=regions/${REGION}/terraform.tfvars \
    -var-file=environments/${ENVIRONMENT}/terraform.tfvars
