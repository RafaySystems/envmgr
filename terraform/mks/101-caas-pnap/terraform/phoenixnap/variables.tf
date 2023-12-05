variable "cluster_name" {
  type    = string
  default = "rafay-phoenixnap-server"
}

variable "type" {
  type = string
  #default = "s1.c1.small"
  default = "s2.c1.medium"
}

variable "location" {
  type    = string
  default = "ASH"
}

variable "os" {
  type    = string
  default = "ubuntu/jammy"
}

variable "total_instances" {
  type    = number
  default = 3
}

variable "cidr_block_size" {
  type    = string
  default = "29"
}
