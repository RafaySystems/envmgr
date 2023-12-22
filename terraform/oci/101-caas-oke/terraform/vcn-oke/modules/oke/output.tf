output "kubeconfig" {
  value     = data.oci_containerengine_cluster_kube_config.test_cluster_kube_config.content
  sensitive = true
}
