variable "project_id" {
  type        = string
  default     = ""
  description = "GCP Project ID"
}

variable "subnetwork" {
  type        = string
  description = "GCP Subnetwork for instance"
}

variable "machine_type" {
  type        = string
  default     = "n1-standard-1"
  description = "GCP Instance type"
}

variable "prefix" {
  type    = string
  default = "abcde"
}
