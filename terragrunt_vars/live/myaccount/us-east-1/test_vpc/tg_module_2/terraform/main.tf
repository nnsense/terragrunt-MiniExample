variable "test_input" {
  type = string
}

variable "region" {
  type = string
}

variable "namespace" {
  type = string
}

variable "name" {
  type = string
}

variable "root_input" {
  type = string
}



output "name" {
  value = var.name
}

output "test_input" {
  value = var.test_input
}

output "root_input" {
  value = var.root_input
}
