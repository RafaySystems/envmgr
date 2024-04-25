variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.0.0.0/16"
}

variable "compute" {
  description = "EC2 Instance Type"
  type        = string
}

variable "guest_os_version" {
  description = "os version"
  type        = string
}

variable "storage" {
  description = "storage capacity in GB"
  type        = string
}

variable "network" {
  description = "subnet name"
  type        = string
}
