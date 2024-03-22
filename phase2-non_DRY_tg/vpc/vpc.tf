module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.25.0"
  cidr_block = "10.0.0.0/24"
  name       = var.environment
}

variable "environment" {
  type        = string
  default     = "mm"
}


# Vars for provider

variable "profile" {
  type        = string
  default     = "default"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}


# Outputs

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}
