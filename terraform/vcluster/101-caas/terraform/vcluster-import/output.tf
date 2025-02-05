output "bootstrap" {
  value     = rafay_import_cluster.vcluster.bootstrap_data
  sensitive = false
}

output "group" {
  value = resource.rafay_group.group-dev.name
}
