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

variable "username" {
  description = "Rafay username"
  type    = string
}

variable "workload_name" {
  type    = string
  default = "jupyterhub"
}

variable "jupyter_admin_password" {
    default = "Jupyt3r"
}

variable "hub_tolerations" {}
variable "singleuser_tolerations" {}
variable "extra_env" {}