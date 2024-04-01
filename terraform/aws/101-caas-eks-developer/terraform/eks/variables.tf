variable "cloud_credential_name" {
  description = "Name of the Rafay cloud credential that will be used for provisioning"
}

variable "node_count" {
  description = "The number of nodes in the cluster"
}

variable "eks_cluster_name" {
  description = "Name of the eks cluster"
}

variable "eks_cluster_project" {
  description = "Name of the project where the cluster will be created in"
}

variable "eks_cluster_region" {
  description = "The region where the EKS cluster will be created"
}

variable "eks_cluster_version" {
  description = "The Kubernetes version the cluster will be built with"
}

variable "eks_cluster_node_instance_type" {
  description = "node instance type"
}

variable "eks_cluster_public_access" {
  description = "public access"
}

variable "username" {
  description = "Rafay username"
  type    = string
}

variable "user_type" {
  description = "Rafay user type (sso or local)"
  type    = string
}

variable "collaborator" {
  type = string
}