variable "aws_region" {
  description = "Configuring AWS as provider"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
}
