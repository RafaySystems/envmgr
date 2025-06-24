terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.17.0"  # or the specific version you need
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "kubeconfig.json"
  }
}
