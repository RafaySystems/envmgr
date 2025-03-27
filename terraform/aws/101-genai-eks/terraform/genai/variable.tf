variable "cluster_name" {
  description = "name of the eks cluster"
}

variable "namespace" {
  description = "namespace for the applications"
}

variable "project" {
  description = "name of the project where the cluster resides"
  type    = string
}
