################################################################################
# VPC
################################################################################

variable "name" {
  description = "Tutorial name"
  type        = string
  default     = "learn-consul"
}

variable "vpc_region" {
  type        = string
  description = "The AWS region to create resources in"
  default     = "us-west-2"
}

################################################################################
# Consul
################################################################################

variable "consul_version" {
  type        = string
  description = "The Consul version"
  default     = "1.17.0"
}

variable "consul_chart_version" {
  type        = string
  description = "The Consul Helm chart version to use"
  default     = "1.3.0"
}

variable "datacenter" {
  type        = string
  description = "The name of the Consul datacenter that client agents should register as"
  default     = "dc1"
}

################################################################################
# Database
################################################################################

variable "postgres_version" {
  type        = string
  description = "The postgres engine version to use"
  default     = "14"
}

################################################################################
# Other
################################################################################

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  name = "${var.name}-${random_string.suffix.result}"
}