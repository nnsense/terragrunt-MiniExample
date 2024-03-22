generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = var.region
  profile = var.profile
}
EOF
}

locals {
  common_vars = yamldecode(file("config.yaml"))
  short_region = run_cmd("--terragrunt-quiet", "make", "-f", "${get_parent_terragrunt_dir()}/Makefile", "-s", "short-region", "region=${local.common_vars.region}")
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "${local.common_vars.environment}-${get_aws_account_id()}-${local.short_region}-tfstate"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = local.common_vars.region
    encrypt = true
  }
}

terraform {
  before_hook "before_hook" {
    commands     = ["apply", "plan"]
    execute      = ["echo", "Running Terraform"]
  }

  after_hook "after_hook" {
    commands     = ["apply", "plan"]
    execute      = ["echo", "Finished running Terraform"]
    run_on_error = true
  }
}
