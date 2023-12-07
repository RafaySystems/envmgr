variable "cluster_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "blueprint" {
  type    = string
  default = "minimal"
}

variable "blueprint_version" {
  type    = string
  default = "latest"
}

variable "group" {
  type = string
}

variable "user" {
  type = string
}
