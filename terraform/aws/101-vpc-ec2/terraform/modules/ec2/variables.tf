variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.medium"
}

variable "subnet_id" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "prefix" {
  type = string
}
