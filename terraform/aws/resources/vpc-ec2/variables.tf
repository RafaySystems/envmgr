variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.small"
}
