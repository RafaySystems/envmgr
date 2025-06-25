terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.17.0"
    }
    rafay = {
      source  = "RafaySystems/rafay"
      version = "1.1.30"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "kubeconfig.json"
  }
}

provider "rafay" {
  provider_config_file = var.rctl_config_path
}
