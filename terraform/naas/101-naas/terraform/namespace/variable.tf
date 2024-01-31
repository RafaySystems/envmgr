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
