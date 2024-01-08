resource "rafay_blueprint" "custom-blueprint" {
  metadata {
    name    = "oke-caas"
    project = var.projectname
  }
  spec {
    version = "v0"
    base {
      name    = "default"
      version = "2.3.0"
    }
    default_addons {
      enable_ingress    = var.ingress
      enable_logging    = var.logging
      enable_monitoring = var.monitoring
      enable_vm         = false
    }
    drift {
      action  = "Deny"
      enabled = var.drift
    }
    placement {
      auto_publish = false
    }
  }
}

resource "rafay_import_cluster" "import_cluster" {
  depends_on = [rafay_blueprint.custom-blueprint]
  clustername           = var.cluster_name
  projectname           = var.projectname
  blueprint             = rafay_blueprint.custom-blueprint.name
  location              = var.location
  kubernetes_provider   = "OTHER"
  provision_environment = "ONPREM"
}
