data "google_project" "cluster" {
  project_id = var.project_id
}

data "google_client_config" "provider" {}