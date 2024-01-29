resource "rafay_namespace" "namespace" {
  metadata {
    name        = var.namespace
    project     = var.project
    labels      = var.labels
    annotations = var.annotations
    description = var.description
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
      cpu_requests             = var.namespace_quotas[var.namespace_quota_size]["cpu_requests"]
      memory_requests          = var.namespace_quotas[var.namespace_quota_size]["memory_requests"]
      cpu_limits               = var.namespace_quotas[var.namespace_quota_size]["cpu_limits"]
      memory_limits            = var.namespace_quotas[var.namespace_quota_size]["memory_limits"]
      config_maps              = var.namespace_quotas[var.namespace_quota_size]["config_maps"]
      persistent_volume_claims = var.namespace_quotas[var.namespace_quota_size]["memory_requests"]
      services                 = var.namespace_quotas[var.namespace_quota_size]["services"]
      pods                     = var.namespace_quotas[var.namespace_quota_size]["pods"]
      replication_controllers  = var.namespace_quotas[var.namespace_quota_size]["replication_controllers"]
      services_load_balancers  = var.namespace_quotas[var.namespace_quota_size]["services_load_balancers"]
      services_node_ports      = var.namespace_quotas[var.namespace_quota_size]["services_node_ports"]
      storage_requests         = var.namespace_quotas[var.namespace_quota_size]["storage_requests"]
      gpu_requests             = var.namespace_quotas[var.namespace_quota_size]["gpu_requests"] != "" ? var.namespace_quotas[var.namespace_quota_size]["gpu_requests"] : ""
      gpu_limits               = var.namespace_quotas[var.namespace_quota_size]["gpu_limits"] != "" ? var.namespace_quotas[var.namespace_quota_size]["gpu_limits"] : ""
    }
  }
}

resource "rafay_group" "group-dev" {
  name = var.group
}

resource "rafay_groupassociation" "groupassociation" {
  project    = var.project
  group      = resource.rafay_group.group-dev.name
  namespaces = [rafay_namespace.namespace.metadata[0].name]
  roles      = ["NAMESPACE_ADMIN"]
  add_users  = [var.user]
}
