output "bootstrap" {
  value = rafay_import_cluster.vcluster.bootstrap_data
  #value     = rafay_import_cluster.vcluster.values_data
  sensitive = true
}

output "group" {
  value = resource.rafay_group.group-dev.name
}
