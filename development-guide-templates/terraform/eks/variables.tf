variable "email_tag" {
  description = "resource tag"
  default = "test@rafay.co"
}

variable "aws_cloud_provider_name" {
  description = "cloud credentials name"
  default = "aws-cloud-creds-1"
}

variable "aws_cloud_provider_access_key" {
  description = "aws access key"
  default = ""
  sensitive = true
}

variable "aws_cloud_provider_secret_key" {
  description = "aws secret key"
  default = ""
  sensitive = true
}

variable "eks_cluster_name" {
  description = "name of the eks cluster"
  default = "eks-cluster-1"
}

variable "eks_cluster_project" {
  description = "name of the project"
  default = "testproject"
}

variable "eks_cluster_region" {
  description = "eks cluster region"
  default = "us-west-2"
}


variable "eks_cluster_version" {
  description = "eks cluster version"
  default = "1.26"
}


variable "eks_cluster_node_instance_type" {
  description = "node instance type"
  default = "t3.large"
}

variable "eks_cluster_public_access" {
  description = "public access"
  default = true
}

variable "eks_public_subnets" {
  description = "public subnets"
}

variable "eks_private_subnets" {
    description = "private subnets"
}
