variable "region" {
  default     = "us-west-2"
  description = "AWS region"
}

variable "name" {
    default = "km-envmgr-demo-vpc"
    description = "vpc name"
}

variable "email" {
  description = "Email tag to be added while creating the resource"
}

variable "env" {
  description = "Env tag to be added while creating the resource"
}

variable "cidr" {
  default = "10.0.0.0/16"
  description = "VPC CIDR"
}

variable "secondary_cidr_blocks" {
  default = ["100.64.0.0/16"]
  description = "List of Secondary VPC CIDR"
}