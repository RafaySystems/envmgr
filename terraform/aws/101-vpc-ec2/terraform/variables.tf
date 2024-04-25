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
  type = map(string)
  description = "list of instance types
  default = {
   "2 vCPU, 2 GiB Memory" = "t3.small"
   "2 vCPU, 4 GiB Memory" = "t3.medium"
   "2 vCPU, 8 GiB Memory" = "t3.large"
   "4 vCPU, 16 GiB Memory" = "t3.xlarge"
   "2 vCPU, 32 GiB Memory" = "t3.2xlarge"
}
}
