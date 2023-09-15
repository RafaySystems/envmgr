variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "ip_cidr_range" {
  type    = string
  default = "192.168.1.0/24"
}

variable "machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "prefix" {
  type    = string
  default = "abc"
}
