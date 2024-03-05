variable "region" {
    type = string
    default = "us-central1"
}
variable "project" {
    type = string
}

variable "name" {
  type        = string
  description = "The name of the VM."
  default     = "demo"
}

variable instance_type {
 description = "Instance type"
 type = string
 default = "e2-micro"
}

variable "cloud_provider" {
  description = "Name of the cloud provider, ex: aws,azure,gcp,oci,etc"
  type = string
}

variable "ssh_public_key" {
  description = "SSH Public Key"
  type = string
}

variable "ssh_user" {
  description = "SSH User"
  type = string
  default = "ubuntu"
}

variable num_instances {
  description = "No of instances to create"
  type = number
  default = 1
}

variable gcp_instance_config {
  description = "Instance configuration"
  type = map(object({
    name          = string
    machine_type = string
    node_disk_size    = number
  }))
}

variable "instance_size" {
  description = "Instance size, ex: small, medium, large"
  type = string
  default = "small"
}

variable security_group_ports {
  description = "List of security group ports to open"
  type = list(string)
    default = ["22","80"]
}