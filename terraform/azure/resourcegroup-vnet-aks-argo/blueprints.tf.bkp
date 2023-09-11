resource "rafay_blueprint" "blueprint" {
  metadata {
    name    = "aks-standard-bp"
    project = var.project
  }
  spec {
    version = "v1"
    base {
      name    = "default-aks"
      version = "1.28.0"
    }
    custom_addons {
        name = "ingress-controller"
        version = "v1.0"
    }
    custom_addons {
        name = "gpu-operator"
        version = "v1.0"
    }
    custom_addons {
        name = "argocd"
        version = "v1.0"
    }
    default_addons {
      enable_ingress    = false
      enable_monitoring = true
    }
    drift {
      action  = "Deny"
      enabled = true
    }
    sharing {
      enabled = false
    }
  }
}