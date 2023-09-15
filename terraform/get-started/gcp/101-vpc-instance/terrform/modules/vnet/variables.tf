variable "project_id" {
  type        = string
  default     = ""
  description = "GCP Project ID"
}

variable "ip_cidr_range" {
  type        = string
  default     = "192.168.1.0/24"
  description = "GCP Subnetwork CIDR"
}

variable "prefix" {
  type    = string
  default = "abcde"
}
