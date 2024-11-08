variable "vpc_name" {
 description = "VPC NAME"
 default     = "example-vpc"
 type        = string
}

variable "vpc_cidr" {
 description = "CIDR block for main"
 type        = string
 default     = "10.0.0.0/16"
}


variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-west-2"
}

variable "prefix" {
  description = "The prefix for the VPC"
  type        = string
  default     = "em"
}

variable "tags" {
 description = "AWS Tags"
 type        = map(string)
 default = {
   "env" = "qa"
 }
}
