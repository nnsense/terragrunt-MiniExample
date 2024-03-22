include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependencies {
  paths = ["../vpc"]
}

dependency "infra" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "temporary-vpc-id"
    igw_id = "temporary-igw-id"
    vpc_cidr_block = "temporary-vpc_cidr-id"
  }
}

inputs = {
  region         = include.root.locals.common_vars.region
  profile        = include.root.locals.common_vars.profile
  vpc_id         = dependency.infra.outputs.vpc_id
  igw_id         = dependency.infra.outputs.igw_id
  vpc_cidr_block = dependency.infra.outputs.vpc_cidr_block
}

terraform {
  before_hook "before_hook" {
    commands     = ["apply"]
    execute      = ["echo", "Creating Subnets"]
  }

  after_hook "after_hook" {
    commands     = ["apply"]
    execute      = ["echo", "Subnets created"]
    run_on_error = false
  }
}
