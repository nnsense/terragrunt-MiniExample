include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  # name       = "myname",
  test_input = "tg_module-VAR"
}

terraform {

  source="terraform"

  after_hook "show_outputs" {
    commands      = ["apply"]
    execute       = ["/bin/bash", "-c", "terraform output -json"]
    run_on_error  = false
  }

  after_hook "show_paths" {
    commands      = ["apply"]
    execute       = ["make", "-f", "${get_parent_terragrunt_dir()}/Makefile", "-s", "show-path", "path=${get_parent_terragrunt_dir()}"]
    run_on_error  = false
  }
}
