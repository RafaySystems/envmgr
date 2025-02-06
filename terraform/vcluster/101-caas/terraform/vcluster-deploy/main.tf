resource "random_string" "resource_code" {
  length  = 4
  special = false
  upper   = false
}

resource "local_file" "vcluster_values" {
  content = templatefile("${path.module}/templates/vcluster-values.tftpl", {
    values = var.bootstrap_data
    distro = var.distro
  })
  filename = "${path.module}/${var.filename}"
}

data "local_file" "vcluster_data" {
  depends_on = [resource.local_file.vcluster_values]
  filename   = "${path.module}/${var.filename}"
}

resource "rafay_namespace" "namespace" {
  metadata {
    name    = var.ns_name
    project = var.host_project
  }
  spec {
    drift {
      enabled = false
    }
    placement {
      labels {
        key   = "rafay.dev/clusterName"
        value = var.host_cluster_name
      }
    }
  }
}

# resource "time_sleep" "wait_30_seconds" {
#   depends_on = [resource.rafay_namespace.namespace]

#   destroy_duration = "30s"
# }

resource "rafay_workload" "vcluster-workload" {
  #depends_on = [resource.time_sleep.wait_30_seconds]
  metadata {
    name    = var.cluster_name
    project = var.host_project
  }
  spec {
    namespace = resource.rafay_namespace.namespace.metadata[0].name
    placement {
      selector = "rafay.dev/clusterName=${var.host_cluster_name}"
    }
    version = "v-${random_string.resource_code.result}"
    artifact {
      type = "Helm"
      artifact {
        values_paths {
          name = "file://${path.module}/${var.filename}"
        }
        repository = var.repository
        chart_name = lookup(var.default_charts, var.distro)
        chart_version = var.chart_version
      }
    }
  }
}
