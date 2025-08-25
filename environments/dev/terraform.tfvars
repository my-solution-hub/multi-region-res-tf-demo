# Dev environment - region-specific configurations
rds_configs = {
  "us-east-1" = {
    instance_class        = "db.t4g.micro"
    allocated_storage     = 20
    max_allocated_storage = 50
  }
  "us-west-2" = {
    instance_class        = "db.t4g.small"
    allocated_storage     = 30
    max_allocated_storage = 100
  }
  "eu-west-1" = {
    instance_class        = "db.t4g.micro"
    allocated_storage     = 20
    max_allocated_storage = 50
  }
  "cn-north-1" = {
    instance_class        = "db.t4g.micro"
    allocated_storage     = 20
    max_allocated_storage = 50
  }
}

memorydb_configs = {
  "us-east-1" = {
    node_type = "db.t4g.small"
  }
  "us-west-2" = {
    node_type = "db.t4g.small"
  }
  "eu-west-1" = {
    node_type = "db.t4g.small"
  }
  "cn-north-1" = {
    node_type = "db.t4g.small"
  }
}

eks_configs = {
  "us-east-1" = {
    node_instance_type = "t3.large"
    node_min_size      = 1
    node_max_size      = 3
    node_desired_size  = 2
  }
  "us-west-2" = {
    node_instance_type = "t3.large"
    node_min_size      = 1
    node_max_size      = 3
    node_desired_size  = 2
  }
  "eu-west-1" = {
    node_instance_type = "t3.large"
    node_min_size      = 1
    node_max_size      = 3
    node_desired_size  = 2
  }
  "cn-north-1" = {
    node_instance_type = "t3.large"
    node_min_size      = 1
    node_max_size      = 3
    node_desired_size  = 2
  }
}
