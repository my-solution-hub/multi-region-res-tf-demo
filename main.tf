terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  # AWS China regions require different endpoints
  dynamic "endpoints" {
    for_each = startswith(var.aws_region, "cn-") ? [1] : []
    content {
      ec2            = "https://ec2.${var.aws_region}.amazonaws.com.cn"
      iam            = "https://iam.cn-north-1.amazonaws.com.cn"
      rds            = "https://rds.${var.aws_region}.amazonaws.com.cn"
      s3             = "https://s3.${var.aws_region}.amazonaws.com.cn"
      sts            = "https://sts.${var.aws_region}.amazonaws.com.cn"
      eks            = "https://eks.${var.aws_region}.amazonaws.com.cn"
    }
  }
}

# VPC using open source module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-${var.environment}-${var.aws_region}"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Environment = var.environment
    Region      = var.aws_region
    Project     = var.project_name
  }
}

# EKS cluster
module "eks" {
  source = "./modules/eks"

  cluster_name = "${var.environment}-${var.aws_region}"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets

  node_instance_type = var.eks_configs[var.aws_region].node_instance_type
  node_min_size      = var.eks_configs[var.aws_region].node_min_size
  node_max_size      = var.eks_configs[var.aws_region].node_max_size
  node_desired_size  = var.eks_configs[var.aws_region].node_desired_size

  access_role_arn = var.eks_access_role_arn

  tags = {
    Environment = var.environment
    Region      = var.aws_region
    Project     = var.project_name
  }
}

# S3 bucket
resource "aws_s3_bucket" "main" {
  bucket = "yagr-demo-${var.environment}-${var.aws_region}"

  tags = {
    Environment = var.environment
    Region      = var.aws_region
    Project     = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ECR repositories
resource "aws_ecr_repository" "hello" {
  name = "hello"

  tags = {
    Environment = var.environment
    Region      = var.aws_region
    Project     = var.project_name
  }
}

resource "aws_ecr_repository" "world" {
  name = "world"

  tags = {
    Environment = var.environment
    Region      = var.aws_region
    Project     = var.project_name
  }
}

# Security group for RDS
resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-${var.environment}-rds"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# RDS MySQL instance
module "rds" {
  source = "./modules/rds"

  name                    = "${var.project_name}-${var.environment}-${var.aws_region}"
  instance_class          = var.rds_configs[var.aws_region].instance_class
  allocated_storage       = var.rds_configs[var.aws_region].allocated_storage
  max_allocated_storage   = var.rds_configs[var.aws_region].max_allocated_storage
  
  db_name  = "appdb"
  username = "admin"
  password = "changeme123!"

  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.rds.id]

  tags = {
    Environment = var.environment
    Region      = var.aws_region
    Project     = var.project_name
  }
}

# Security group for MemoryDB
resource "aws_security_group" "memorydb" {
  name_prefix = "${var.project_name}-${var.environment}-memorydb"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# MemoryDB subnet group
resource "aws_memorydb_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-${var.aws_region}"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Environment = var.environment
    Region      = var.aws_region
    Project     = var.project_name
  }
}

# MemoryDB cluster
resource "aws_memorydb_cluster" "main" {
  name               = "${var.project_name}-${var.environment}-${var.aws_region}"
  acl_name           = "open-access"
  node_type          = var.memorydb_configs[var.aws_region].node_type
  num_shards         = 1
  subnet_group_name  = aws_memorydb_subnet_group.main.name
  security_group_ids = [aws_security_group.memorydb.id]

  tags = {
    Environment = var.environment
    Region      = var.aws_region
    Project     = var.project_name
  }
}
