terraform {
  backend "s3" {
    # Backend configuration will be provided via backend config files
    # Global regions: yagr-tfstate-log-us
    # China regions: yagr-tfstate-log-cn
  }
}
