locals {
  name     = "eks-automode7"
}

data "rafay_download_kubeconfig" "kubeconfig_cluster" {
  cluster = local.name
}

output "kubeconfig" {
  value = yamldecode(data.rafay_download_kubeconfig.kubeconfig_cluster.kubeconfig)
}
