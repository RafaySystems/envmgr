variable "target_cluster_name" {
  description = "name of the eks cluster"
  default     = "eks-cluster-1"
}

variable "project" {
  description = "name of the project where the cluster resides"
  type        = string
  default     = "eaas"
}
