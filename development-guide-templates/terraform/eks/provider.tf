terraform {
  backend "local" {}
  required_providers {
    rafay = {
      version = "= 1.1.15"
      source = "registry.terraform.io/RafaySystems/rafay"
    }
  }
}

provider "aws" {
  region = var.eks_cluster_region
}
