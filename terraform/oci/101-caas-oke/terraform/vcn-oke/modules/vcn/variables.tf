variable "region" {
  type    = string
  default = "phx"
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
