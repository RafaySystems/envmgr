variable "region" {
  type    = string
  default = "phx"
}

variable "cluster_name" {
  type = string
}

variable "size" {
  type    = number
  default = 1
}

variable "compartment_id" {
  type = string
}

variable "vcn_name" {
  type = string
}

variable "vcn_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "k8s_version" {
  type    = string
  default = "v1.27.2"
}

variable "image" {
  type = string
}

variable "availability_domain" {
  type    = string
  default = "PaOl:PHX-AD-1"
}
