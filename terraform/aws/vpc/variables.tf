variable "region" {
  default     = "us-west-2"
  description = "AWS region"
}

variable "name" {
  default     = "envmgr-demo-vpc"
  description = "vpc name"
}

variable "email" {
  description = "Email tag to be added while creating the resource"
}
