# Multi-Regional AWS Resource Deployment Demo

This project demonstrates deploying AWS resources per region using Terraform with environment variables.

## Prerequisites

- **Terraform** >= 1.0 installed
- **AWS CLI** installed and configured
- **AWS credentials** with administrative permissions
- **kubectl** (optional, for EKS cluster management)

### AWS Configuration

Configure AWS credentials using one of these methods:

```bash
# Method 1: AWS CLI configure
aws configure

# Method 2: Environment variables
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"

# Method 3: AWS Profile
export AWS_PROFILE="your-profile-name"
```

**Required AWS Permissions:**

- EC2, VPC, IAM, EKS, RDS, MemoryDB, S3, ECR
- Administrative access recommended for initial setup

## Structure

- `modules/` - Reusable Terraform modules
- `environments/` - Environment-specific configurations
- `regions/` - Region-specific configurations with terraform.tfvars
- `scripts/` - Deployment scripts
- `main.tf` - Main Terraform configuration
- `variables.tf` - Input variables
- `outputs.tf` - Output values

## Quick Start

```bash
# Initialize Terraform
./scripts/init.sh

# Plan deployment
./scripts/plan.sh dev us-east-1

# Deploy infrastructure
./scripts/deploy.sh dev us-east-1

# Destroy infrastructure
./scripts/destroy.sh dev us-east-1
```

## Manual Usage

Deploy to a specific region with environment using environment variables:

```bash
# Deploy to us-east-1 with dev environment (t4g.micro RDS)
export TF_VAR_environment=dev
export TF_VAR_region=us-east-1
terraform init
terraform plan -var-file=regions/${TF_VAR_region}/terraform.tfvars -var-file=environments/${TF_VAR_environment}/terraform.tfvars
terraform apply -var-file=regions/${TF_VAR_region}/terraform.tfvars -var-file=environments/${TF_VAR_environment}/terraform.tfvars

# Deploy to us-west-2 with prod environment (m5.xlarge RDS)
export TF_VAR_environment=prod
export TF_VAR_region=us-west-2
terraform plan -var-file=regions/${TF_VAR_region}/terraform.tfvars -var-file=environments/${TF_VAR_environment}/terraform.tfvars
terraform apply -var-file=regions/${TF_VAR_region}/terraform.tfvars -var-file=environments/${TF_VAR_environment}/terraform.tfvars
```

## Available Regions

- us-east-1 (10.0.0.0/16)
- us-west-2 (10.1.0.0/16)
- eu-west-1 (10.2.0.0/16)

## Environment Configurations

### Dev Environment

- **us-east-1**: db.t4g.micro, 20GB storage
- **us-west-2**: db.t4g.small, 30GB storage
- **eu-west-1**: db.t4g.micro, 20GB storage

### Prod Environment

- **us-east-1**: db.m5.large, 100GB storage
- **us-west-2**: db.m5.xlarge, 200GB storage
- **eu-west-1**: db.m5.large, 100GB storage
