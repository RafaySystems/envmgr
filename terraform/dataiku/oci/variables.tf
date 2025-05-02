variable "region" {}
variable "compartment_ocid" {}
variable "subnet_id" {}
variable "instance_shape" {}
variable "ssh_public_key" {}

variable "remote_host" {
  description = "Public IP or DNS of the remote server"
  type        = string
  default     = "dummy"
}

variable "remote_user" {
  description = "SSH username (e.g., ubuntu, root)"
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key" {
  description = "Contents of the private SSH key"
  type        = string
  sensitive   = true
}
