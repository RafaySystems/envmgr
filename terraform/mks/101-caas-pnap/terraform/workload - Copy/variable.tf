variable "ns_name" {
  type    = string
  default = "eaas"
}

variable "project" {
  type    = string
}

variable "cluster_name" {
  type    = string
}

variable "workload_name" {
  type    = string
  default = "wk1"
}

variable "hostname" {
  type    = string
  default = "wordpress.demo.gorafay.net"
}
