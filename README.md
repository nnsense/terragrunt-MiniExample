# terragrunt_mini_aws_examples

Terragrunt is a great tool to deploy large, multi-account infrastructure, but it seems the "path" to understand how it works is steep, and often misleading.

One of the most misunderstood features is how terragrunt deals with variables. Terragrunt has a completely different approach to it, defintiely it's not just an alternative to `terraform.tfvars`.

The directories in this repo are the steps to get the same deployment from plain terraform to full terragrunt.

The directory "terragrunt_vars" is showing how terraform is building his vars, and it is also demostrating how its functions are working.

