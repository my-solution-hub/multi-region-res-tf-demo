output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.main.bucket
}

output "ecr_repositories" {
  description = "ECR repository URLs"
  value = {
    hello = aws_ecr_repository.hello.repository_url
    world = aws_ecr_repository.world.repository_url
  }
}

output "memorydb_cluster_endpoint" {
  description = "MemoryDB cluster endpoint"
  value       = aws_memorydb_cluster.main.cluster_endpoint[0].address
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.db_instance_endpoint
}

output "region" {
  description = "Deployed region"
  value       = var.aws_region
}

output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "environment" {
  description = "Environment"
  value       = var.environment
}
