

variable "eks_cluster_name" {
  description = "name of the eks cluster"
  default = "eks-cluster-1"
}

variable "eks_cluster_project" {
  description = "name of the project"
  default = "testproject"
}

variable "dns_name" {
  default = "envmgr-app1"
}

variable "dns_zone" {
  default = "dev.rafay-edge.net"
}


