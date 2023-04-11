terraform {
  backend "local" {}
  required_providers {
    rafay = {
      version = "= 1.1.5"
      source = "registry.terraform.io/RafaySystems/rafay"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.19.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "4.62.0"
    }
  }
  required_version = "= 1.4.4"
}

provider "kubernetes" {
  config_path    = var.kubernetes_config_file
  config_context = var.eks_cluster_name
}

provider "rafay" {
  provider_config_file = var.rafay_config_file
}

variable "rafay_config_file" {
  description = "rafay provider config file for authentication"
  default     = "/opt/rafay/rctl.conf"
}

variable "kubernetes_config_file" {
  description = "rafay provider config file for authentication"
  default     = "kubeconfig.yaml"
}
