resource "rafay_repositories" "opa_repository" {

  metadata {
    name    = var.repo_name
    project = var.project
  }
  
  spec {
    endpoint = var.endpoint
    type     = var.type
  }
}