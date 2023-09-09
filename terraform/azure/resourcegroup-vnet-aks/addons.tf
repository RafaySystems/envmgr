resource "rafay_addon" "ingress-controller" {
  metadata {
    name    = "ingress-controller"
    project = var.project
  }
  spec {
    namespace = "ingress-nginx"
    version   = "v1.0"
    artifact {
      type = "Helm"
      artifact {
        catalog = "default-helm"
        chart_name = "ingress-nginx"
        chart_version = "4.7.1"
        /*values_paths {
          name = "file://relative/path/to/some/chart/values.yaml"
        }*/
      }
    }
  }
}

resource "rafay_addon" "argocd" {
  metadata {
    name    = "argocd"
    project = var.project
  }
  spec {
    namespace = "argocd"
    version   = "v1.0"
    artifact {
      type = "Helm"
      artifact {
        catalog = "default-helm"
        chart_name = "argo-cd"
        chart_version = "5.38.1"
        /*values_paths {
          name = "file://relative/path/to/some/chart/values.yaml"
        }*/
      }
    }
  }
}

resource "rafay_addon" "gpu-operator" {
  metadata {
    name    = "gpu-operator-resources"
    project = var.project
  }
  spec {
    namespace = "gpu-operator"
    version   = "v1.0"
    artifact {
      type = "Helm"
      artifact {
        catalog = "default-helm"
        chart_name = "gpu-operator"
        chart_version = "v23.3.2"
        values_paths {
          name = "file://artifacts/gpu-operator-values.yaml"
        }
      }
    }
  }
}