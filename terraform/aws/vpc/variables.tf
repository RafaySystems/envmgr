variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "VPC NAME"
  default     = "example-vpc"
  type        = string
}


variable "tags" {
  description = "AWS Tags"
  type        = map(string)
  default = {
    "cluster-name" = "demo-cluster"
  }
}
