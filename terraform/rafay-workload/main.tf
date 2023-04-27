resource "rafay_namespace" "namespace" {
  metadata {
    name    = var.workload_namespace
    project = var.workload_project
  }
  spec {
    drift {
      enabled = true
    }
    placement {
      labels {
        key   = "rafay.dev/clusterName"
        value = var.cluster_name
      }
    }
  }
}

resource "rafay_workload" "workload" {
  metadata {
    name    = var.workload_name
    project = var.workload_project
  }
  spec {
    namespace = var.workload_namespace
    placement {
      selector = "rafay.dev/clusterName=${var.cluster_name}"
    }
    version = "v1"
    artifact {
      type = "Helm"
      artifact {
        chart_path {
          name = var.workload_helm_chart_path
        }
        values_paths {
          name = var.workload_helm_chart_values_path
        }
        repository = var.workload_helm_gitrepo
        revision   = var.workload_helm_gitrepo_revision
      }
    }
  }
}