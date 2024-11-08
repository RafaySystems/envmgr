terraform {
  required_providers {
    rafay = {
      version = ">= 0.1"
      source  = "registry.terraform.io/RafaySystems/rafay"
    }
  }
}

provider "aws" {
  region = var.eks_cluster_region
}
