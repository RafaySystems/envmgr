variable "name" {
  type        = string
  description = "Base name for AWS resources"
}

data "rafay_download_kubeconfig" "kubeconfig_cluster" {
  cluster = var.name
}

output "kubeconfig" {
  value = yamldecode(data.rafay_download_kubeconfig.kubeconfig_cluster.kubeconfig)
}
