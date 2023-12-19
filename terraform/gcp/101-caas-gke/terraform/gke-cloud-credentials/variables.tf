variable "project_name" {
  type = string
}

variable "filename" {
  type    = string
  default = "gcp-credentails.json"
}

variable "credentials_name" {
  type    = string
  default = "gke-credentials"
}
