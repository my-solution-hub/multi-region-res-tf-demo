# Prod environment - region-specific configurations
rds_configs = {
  "us-east-1" = {
    instance_class        = "db.m5.large"
    allocated_storage     = 100
    max_allocated_storage = 500
  }
  "us-west-2" = {
    instance_class        = "db.m5.xlarge"
    allocated_storage     = 200
    max_allocated_storage = 1000
  }
  "eu-west-1" = {
    instance_class        = "db.m5.large"
    allocated_storage     = 100
    max_allocated_storage = 500
  }
}

memorydb_configs = {
  "us-east-1" = {
    node_type = "db.r7g.large"
  }
  "us-west-2" = {
    node_type = "db.r7g.xlarge"
  }
  "eu-west-1" = {
    node_type = "db.r7g.large"
  }
}

eks_configs = {
  "us-east-1" = {
    node_instance_type = "m5.large"
    node_min_size      = 2
    node_max_size      = 10
    node_desired_size  = 3
  }
  "us-west-2" = {
    node_instance_type = "m5.xlarge"
    node_min_size      = 3
    node_max_size      = 15
    node_desired_size  = 5
  }
  "eu-west-1" = {
    node_instance_type = "m5.large"
    node_min_size      = 2
    node_max_size      = 10
    node_desired_size  = 3
  }
}
