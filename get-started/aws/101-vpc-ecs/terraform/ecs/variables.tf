variable "aws_region" {
  description = "Configuring AWS as provider"
  type        = string
  default     = "us-west-2"
}

variable "vpc_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ingress_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}
