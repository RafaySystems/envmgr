variable "project_name" {
  type = string
}

variable "group" {
  type = string
}

variable "user" {
  type = string
}

variable "roles" {
  type    = list(string)
  default = ["PROJECT_ADMIN", "CLUSTER_ADMIN"]
}
