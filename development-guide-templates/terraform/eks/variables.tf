variable "aws_region" {
  description = "Configuring AWS as provider"
  type        = string
  default     = "us-west-2"
}

variable "aws_cloud_provider_name" {
  description = "cloud credentials name"
  default     = "aws-cloud-creds-1"
}

variable "aws_access_key_id" {
  description = "aws access key"
  default     = ""
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "aws secret key"
  default     = ""
  sensitive   = true
}

variable "cluster_name" {
  description = "name of the eks cluster"
  default     = "eks-cluster-1"
}

variable "project" {
  description = "name of the project"
  default     = "dev-project"
}

variable "eks_cluster_version" {
  description = "eks cluster version"
  default     = "1.26"
}

variable "eks_cluster_node_instance_type" {
  description = "node instance type"
  default     = "t3.large"
}

variable "eks_cluster_public_access" {
  description = "public access"
  default     = true
}

variable "eks_public_subnets" {
  description = "public subnets"
}

variable "eks_private_subnets" {
  description = "private subnets"
}

variable "tags" {
  description = "AWS Tags"
  type        = map(string)
  default = {
    "env"   = "qa"
    "email" = "test@rafay.co"
  }
}
