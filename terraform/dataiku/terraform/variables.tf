variable "remote_host" {
  description = "Public IP or DNS of the remote server"
  type        = string
}

variable "remote_user" {
  description = "SSH username (e.g., ubuntu, root)"
  type        = string
  default     = "ubuntu"
}

variable "private_key_path" {
  description = "Path to the private SSH key"
  type        = string
}
