resource "random_id" "rnd" {
  keepers = {
    first = var.cluster_name
  }
  byte_length = 4
}

locals {
  # Create a unique namspace name
  namespace1 = "${element(split("@",var.username),0)}-${random_id.rnd.dec}"
  namespace2 = replace(local.namespace1,"+","-")
  namespace3 = replace(local.namespace2,".","-")
  namespace4 = replace(local.namespace3,"+","-")
  namespace = lower(local.namespace4)
}

resource "rafay_namespace" "namespace" {
  metadata {
    name        = local.namespace
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
  name = local.namespace
}

resource "rafay_groupassociation" "groupassociation" {
  project    = var.project
  group      = resource.rafay_group.group-dev.name
  namespaces = [rafay_namespace.namespace.metadata[0].name]
  roles      = ["NAMESPACE_ADMIN"]
  add_users  = [var.username]
}

data "rafay_download_kubeconfig" "kubeconfig_cluster" {
  #cluster = var.cluster_name
  username = var.username
}
