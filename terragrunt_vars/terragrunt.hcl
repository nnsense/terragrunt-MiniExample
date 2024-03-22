generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket                 = "gc-${local.account_id}-tfstate"
    key                    = "${path_relative_to_include()}/terraform.tfstate"
    region                 = local.region
    encrypt                = true
    skip_bucket_versioning = false
  }
}

locals {
  # Terragrunt will recursively look for this file from each deployment
  namespace_vars  = try(read_terragrunt_config(find_in_parent_folders("namespace.hcl")), "")
  account_vars    = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars     = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  name_vars       = read_terragrunt_config(find_in_parent_folders("name.hcl"))

  # Extract the variables we need for easy access from *this terragrunt.hcl*
  region          = local.region_vars.locals.region
  account_id      = local.account_vars.locals.aws_account_id
}

inputs = {
  namespace      = local.namespace_vars.locals.namespace
  region         = local.region
  name           = local.name_vars.locals.name
  root_input     = "root-input"
}

terraform {

  before_hook "output_bucket" {
    commands = ["init", "apply"]
    execute  = ["echo", "Hi from the root's before_hook"]
  }
}
