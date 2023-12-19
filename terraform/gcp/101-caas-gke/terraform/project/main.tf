resource "rafay_project" "vcluster_project" {
  metadata {
    name = var.project_name
  }
  spec {
    default = false
  }
}
