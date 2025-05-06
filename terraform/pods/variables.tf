variable "remote_host" {
  description = "Public IP or DNS of the remote server"
  type        = string
  default     = "137.131.3.90"
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
