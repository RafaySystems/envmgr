variable "vpc_name" {
  description = "VPC name"
  default     = "example-vpc"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "tags" {
  description = "AWS Tags"
  type        = map(string)
  default = {
    "env"   = "qa"
    "email" = "test@rafay.co"
  }
}

variable "aws_access_key_id" {
  description = "aws access key id"
  default     = ""
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "aws secret key"
  default     = ""
  sensitive   = true
}
