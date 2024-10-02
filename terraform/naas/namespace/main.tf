resource "rafay_namespace" "tf-namespace" {
  metadata {
    name    = var.namespace
    project = var.project
    #labels = merge(var.namespace_labels)
  }
  spec {
    drift {
      enabled = false
    }
    placement {
      labels {
        key   = "rafay.dev/clusterName"
        value = var.cluster_name
      }
    }
  }
}
