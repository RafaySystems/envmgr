resource "random_id" "rnd" {
  keepers = {
    first = "${timestamp()}"
  }
  byte_length = 4
}

resource "rafay_namespace" "namespace" {
  metadata {
    name    = var.ns_name
    project = var.project
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
  depends_on = [rafay_namespace.namespace, random_id.rnd]
  metadata {
    name    = var.workload_name
    project = var.project
  }
  spec {
    namespace = var.ns_name
    placement {
      selector = "rafay.dev/clusterName=${var.cluster_name}"
    }
    version = "v-${random_id.rnd.hex}"
    artifact {
      type = "Yaml"
      artifact {
        paths {
          name = "file://workload.yaml"
        }
      }
    }
  }
}