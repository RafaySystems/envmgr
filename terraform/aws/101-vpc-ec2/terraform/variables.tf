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

variable "isntance_map" {
  type = "list"
  description = "list of instance types
  default = [
      {
        id = "2 vCPU, 2 GiB Memory"
        attribute = "t3.small"
      },
      {
        id = "2 vCPU, 4 GiB Memory"
        attribute = "t3.medium"
      },
      {
        id = "2 vCPU, 8 GiB Memory"
        attribute = "t3.large"
      },
      {
        id = "4 vCPU, 16 GiB Memory"
        attribute = "t3.xlarge"
      },
      {
        id = "8 vCPU, 32 GiB Memory"
        attribute = "t3.2xlarge"
      }
  ]
}
