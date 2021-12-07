include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  profile = include.root.locals.common_vars.profile
  region = include.root.locals.common_vars.region
  environment = include.root.locals.common_vars.environment
}

terraform {
  before_hook "before_hook" {
    commands     = ["apply"]
    execute      = ["echo", "Creating VPC"]
  }

  after_hook "after_hook" {
    commands     = ["apply"]
    execute      = ["echo", "VPC created"]
    run_on_error = false
  }
}