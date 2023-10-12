variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.small"
}

variable "subnet_id" {
  type = string
}

variable "prefix" {
  type = string
}
