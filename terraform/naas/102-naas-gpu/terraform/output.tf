output "namespace" {
  value = local.namespace
}

output "kubeconfig" {
  description = "Rafay ZTKA kubeconfig of the cluster"
  value       = data.rafay_download_kubeconfig.kubeconfig_cluster.kubeconfig
}

output "ztka" {
  value = "https://console.rafay.dev/#/console/${var.projectid}/${var.cluster_name}?&namespace=${local.namespace}"
}
