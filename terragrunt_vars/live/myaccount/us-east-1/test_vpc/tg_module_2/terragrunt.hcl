include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependencies {                                                                                            
  paths = ["../tg_module"]
}

dependency "tg_module" {
  config_path = "../tg_module"
  mock_outputs = {
    tg_module_output = "mock"
  }
}

locals {
  tf_vars = try(yamldecode(file("${get_terragrunt_dir()}/variables.yaml")), {})
}

inputs = merge(
  local.tf_vars,
  {
    test_input = dependency.tg_module.outputs.tg_module_output
  }
)

terraform {

  source="terraform"

  after_hook "show_outputs" {
    commands      = ["apply"]
    execute       = ["/bin/bash", "-c", "terraform output -json"]
    run_on_error  = false
  }

  after_hook "show_paths" {
    commands      = ["apply"]
    execute       = ["make", "-f", "${get_parent_terragrunt_dir()}/Makefile", "-s", "show-path", "path=${find_in_parent_folders()}"]
    run_on_error  = false
  }
}
