data "rafay_download_kubeconfig" "kubeconfig_cluster" {
  cluster = local.name
  depends_on = [null_resource.delete-webhook]
}

output "kubeconfig" {
  value = yamldecode(data.rafay_download_kubeconfig.kubeconfig_cluster.kubeconfig)
   #depends_on = [rafay_import_cluster.import_cluster]
}
