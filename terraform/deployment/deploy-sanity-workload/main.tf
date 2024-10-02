locals {
  version = timestamp()
}

resource "rafay_workload" "workload" {
  metadata {
    name    = var.sanity_workload_name
    project = var.sanity_project
  }
  spec {
    namespace = var.ns_name
    placement {
      selector = "canary=${var.sanity_phase}"
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
          revision   = var.revision
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
