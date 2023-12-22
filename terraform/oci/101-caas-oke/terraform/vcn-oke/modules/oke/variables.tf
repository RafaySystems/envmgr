variable "region" {
  type    = string
  default = "phx"
}

variable "cluster_name" {
  type    = string
  default = "oke_rafay"
}

variable "size" {
  type    = number
  default = 1
}

variable "compartment_id" {
  type = string
}

variable "vcn_id" {
  type = string
}

variable "k8s_version" {
  type    = string
  default = "v1.27.2"
}

variable "image" {
  type = string
}

variable "nsg_ids" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "availability_domain" {
  type    = string
  default = "PaOl:PHX-AD-1"
}
