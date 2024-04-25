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

variable "instance_map" {
  type = map(string)
  description = "list of instance types"
  default = {
   "2 vCPU, 2 GiB Memory" = "t3.small"
   "2 vCPU, 4 GiB Memory" = "t3.medium"
   "2 vCPU, 8 GiB Memory" = "t3.large"
   "4 vCPU, 16 GiB Memory" = "t3.xlarge"
   "8 vCPU, 32 GiB Memory" = "t3.2xlarge"
}
}

variable "ami_map" {
  type = map(string)
  description = "list of amis"
  default = {
   "Ubuntu 22.04 64-bit" = "ami-08116b9957a259459"
   "Ubuntu 20.04 64-bit" = "ami-0eb199b995e2bc4e3"
   "Red Hat Enterprise Linux 9 64-bit" = "ami-0f7197c592205b389"
   "SUSE 15 SP5 64-bit" = "ami-011fa029a966edf23"
   "Microsoft Windows Server 2022 64-bit" = "ami-0c0ec0a3a3a4c34c0"
   "Microsoft Windows Server 2019 64-bit" = "ami-04eb6bba8a64bfa5b"
   "Microsoft Windows Server 2016 64-bit" = "ami-0914aba291f5f5c83"
}
}
