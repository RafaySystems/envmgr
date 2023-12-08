resource "rafay_project" "vcluster_project" {
  metadata {
    name = var.project_name
  }
  spec {
    default = false
  }
}

resource "rafay_import_cluster" "vcluster" {
  clustername           = var.cluster_name
  projectname           = rafay_project.vcluster_project.id
  blueprint             = var.blueprint
  blueprint_version     = var.blueprint_version
  kubernetes_provider   = "OTHER"
  provision_environment = "CLOUD"
  bootstrap_path        = "bootstrap.yaml"
}

resource "rafay_group" "group-dev" {
  name = var.group
}

resource "rafay_groupassociation" "groupassociation" {
  project   = rafay_project.vcluster_project.id
  group     = resource.rafay_group.group-dev.name
  roles     = ["PROJECT_ADMIN"]
  add_users = [var.user]
}
