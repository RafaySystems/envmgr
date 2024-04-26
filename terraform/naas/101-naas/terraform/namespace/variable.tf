variable "cluster_name" {
  description = "name of the eks cluster"
  default = "eks-cluster-1"
}

variable "project" {
  description = "name of the project where the cluster resides"
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
  type = string
}

variable "network_policy" {
  type = string
}

variable "network_policy_version" {
  type = string
}
