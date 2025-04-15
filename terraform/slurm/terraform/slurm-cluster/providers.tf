provider "helm" {
  kubernetes {
    config_path = "kubeconfig.json"
  }
}

terraform {
  required_providers {
    rafay = {
      source  = "RafaySystems/rafay"
      version = "1.1.30"
    }
  }
}

provider "rafay" {
  provider_config_file = var.rctl_config_path
}
