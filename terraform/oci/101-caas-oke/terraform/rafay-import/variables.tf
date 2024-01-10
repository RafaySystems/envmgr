variable "cluster_name" {
  type = string
}

variable "location" {
  type    = string
  default = "sanjose-us"
}

variable "projectname" {
  type = string
}

variable "ingress" {
  type    = string
  default = "true"
}

variable "logging" {
  type    = string
  default = "true"
}

variable "monitoring" {
  type    = string
  default = "false"
}

variable "drift" {
  type    = string
  default = "true"
}
