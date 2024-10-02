locals {
  version = timestamp()
}

resource "rafay_workload" "workload" {
  #count = var.continue == "true" ? 1 : 0
  metadata {
    name    = var.workload_name
    project = var.project
  }
  spec {
    namespace = var.ns_name
    placement {
      selector = "canary=${var.phase}"
    }
    version = "${var.revision}-${local.version}"
    artifact {
      type = "Helm"
      artifact {
        catalog       = var.catalog
        chart_name    = var.chart
        chart_version = var.chart_version
        values_ref {
          repository = var.values_repo
          revision   = var.main_revision
          values_paths {
            name = var.custom_value_path
          }
        }
      }
    }
  }
  timeouts {
    create = "10m"
  }
}
