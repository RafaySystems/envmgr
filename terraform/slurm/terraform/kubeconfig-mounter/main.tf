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

data "rafay_download_kubeconfig" "kubeconfig_cluster" {
  cluster = var.cluster_name
}

output "kubeconfig" {
  value = yamldecode(data.rafay_download_kubeconfig.kubeconfig_cluster.kubeconfig)
}

resource "rafay_download_kubeconfig" "tfkubeconfig" {
  cluster            = var.cluster_name
  output_folder_path = "/tmp"
  filename           = "kubeconfig"
}
