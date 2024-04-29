resource "rafay_namespace" "namespace" {
  metadata {
    name        = var.namespace
    project     = var.project
    labels      = var.labels
    annotations = var.annotations
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
    resource_quotas {
      cpu_requests    = var.namespace_quotas[var.namespace_quota_size]["cpu_requests"]
      memory_requests = var.namespace_quotas[var.namespace_quota_size]["memory_requests"]
      cpu_limits      = var.namespace_quotas[var.namespace_quota_size]["cpu_limits"]
      memory_limits   = var.namespace_quotas[var.namespace_quota_size]["memory_limits"]
      gpu_requests    = var.namespace_quotas[var.namespace_quota_size]["gpu_requests"]
      gpu_limits      = var.namespace_quotas[var.namespace_quota_size]["gpu_limits"]
    }
  }
}

# resource "rafay_group" "group-dev" {
#   name = var.group
# }

# resource "rafay_groupassociation" "groupassociation" {
#   project    = var.project
#   group      = resource.rafay_group.group-dev.name
#   namespaces = [rafay_namespace.namespace.metadata[0].name]
#   roles      = ["NAMESPACE_ADMIN"]
#   add_users  = [var.user]
# }
