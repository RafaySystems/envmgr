resource "random_id" "rnd" {
  keepers = {
    first = "${timestamp()}"
  }
  byte_length = 4
}

resource "random_password" "password" {
  length  = 8
  special = false
}

resource "local_sensitive_file" "workload_values" {
  depends_on = [random_id.rnd, random_password.password]
  content = templatefile("${path.module}/templates/values.tftpl", {
    hostname = var.hostname
    secret   = random_password.password.result
  })
  filename        = "values.yaml"
  file_permission = "0666"
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
      type = "Helm"
      artifact {
        values_paths {
          name = "file://values.yaml"
        }
        catalog    = "default-bitnami"
        chart_name = "wordpress"
      }
    }
  }
}