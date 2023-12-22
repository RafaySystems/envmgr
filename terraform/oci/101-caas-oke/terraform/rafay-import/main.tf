resource "rafay_import_cluster" "import_cluster" {
  clustername           = var.cluster_name
  projectname           = var.projectname
  blueprint             = var.blueprint
  location              = var.location
  kubernetes_provider   = "OTHER"
  provision_environment = "ONPREM"
}
