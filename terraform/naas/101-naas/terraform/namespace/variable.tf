variable "cluster_name" {
  description = "name of the cluster that the namespace will be created in"
  default = "naas-cluster-1"
}

variable "project" {
  description = "Name of the project where the host cluster resides"
  type    = string
  default = "eaas"
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
  description = "Namespace CPU requests"
  type    = string
  default = "2000m"
}

variable "memory" {
  description = "Namespace memory requests"
  type    = string
  default = "2048Mi"
}

variable "collaborator" {
  description = "Email address of a user who will be granted access to the environment resources"
  type = string
}