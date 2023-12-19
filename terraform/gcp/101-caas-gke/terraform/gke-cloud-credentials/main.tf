
resource "rafay_cloud_credentials_v3" "gke-credentials" {
  metadata {
    name    = var.credentials_name
    project = var.project_name
  }
  spec {
    type     = "ClusterProvisioning"
    provider = "gcp"
    credentials {
      file = filebase64("${path.module}/${var.filename}")
    }
  }
}
