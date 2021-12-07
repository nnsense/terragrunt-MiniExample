module "subnets" {
  source                          = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.39.3"
  vpc_id                          = var.vpc_id
  igw_id                          = var.igw_id
  cidr_block                      = var.vpc_cidr_block
  nat_gateway_enabled             = false
  availability_zones              = local.az
  aws_route_create_timeout        = "5m"
  aws_route_delete_timeout        = "10m"
}

variable "vpc_id" {}
variable "igw_id" {}
variable "vpc_cidr_block" {}
variable "az" { default = null }
variable "region" { default = null }
variable "profile" { default = "default" }

locals {
  az = var.az == null ? [ "${var.region}a", "${var.region}b", "${var.region}c" ] : var.az
}