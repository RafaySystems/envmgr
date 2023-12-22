output "cluster-name" {
  value = rafay_import_cluster.import_cluster.clustername
}

output "blueprint-name" {
  value = rafay_import_cluster.import_cluster.blueprint
}

output "project-name" {
  value = rafay_import_cluster.import_cluster.projectname
}

output "cluster-location" {
  value = rafay_import_cluster.import_cluster.location
}

output "bootstrap" {
  value = rafay_import_cluster.import_cluster.bootstrap_data
}
