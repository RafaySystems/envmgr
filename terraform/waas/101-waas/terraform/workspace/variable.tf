variable "cluster_name" {
  description = "name of the eks cluster"
}

variable "project" {
  description = "name of the project where the cluster resides"
  type    = string
}

variable "username" {
  description = "Rafay username"
  type    = string
}

variable "user_type" {
  description = "Rafay user type (sso or local)"
  type    = string
}

variable "cpu" {
  description = "Workspace CPU requests"
  type    = string
  default = "2000m"
}

variable "memory" {
  description = "Workspace memory requests"
  type    = string
  default = "2048Mi"
}

variable "collaborator" {
  type = string
}