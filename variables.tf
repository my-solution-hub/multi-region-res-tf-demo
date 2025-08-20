variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "multi-region-demo"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

# RDS Configuration per region
variable "rds_configs" {
  description = "RDS configuration per region"
  type = map(object({
    instance_class        = string
    allocated_storage     = number
    max_allocated_storage = number
  }))
}

# MemoryDB Configuration per region
variable "memorydb_configs" {
  description = "MemoryDB configuration per region"
  type = map(object({
    node_type = string
  }))
}

# EKS Configuration per region
variable "eks_configs" {
  description = "EKS configuration per region"
  type = map(object({
    node_instance_type = string
    node_min_size      = number
    node_max_size      = number
    node_desired_size  = number
  }))
}

# EKS Access Role
variable "eks_access_role_arn" {
  description = "IAM role ARN to grant full EKS access (optional)"
  type        = string
  default     = ""
}
