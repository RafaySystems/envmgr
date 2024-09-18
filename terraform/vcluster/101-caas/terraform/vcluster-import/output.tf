output "bootstrap" {
  value     = rafay_import_cluster.vcluster.bootstrap_data
  sensitive = true
}

/*output "group" {
  value = resource.rafay_group.group-dev.name
}*/

output "group" {
  value = rafay_group.dgx-group.name
}

output "collab_group" {
  value = rafay_group.collab-group.name
}