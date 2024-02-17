resource "random_id" "rnd" {
  keepers = {
    first = var.cluster_name
  }
  byte_length = 4
}

locals {
  # Create a unique namspace name
  namespace = "${element(split("@",var.username),0)}-${random_id.rnd.dec}"
}

resource "rafay_namespace" "namespace" {
  metadata {
    name    = local.namespace
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
    resource_quotas {
		config_maps = "15"
		cpu_requests = var.cpu
		memory_requests = var.memory
                cpu_limits = "4000m"
                memory_limits = "4096Mi"
		persistent_volume_claims = "2"
		pods = "30"
		replication_controllers = "5"
		services = "10"
		services_load_balancers = "10"
		services_node_ports = "10"
		storage_requests = "50Gi"
	}
}
  }


resource "rafay_group" "group" {
  name        = "${local.namespace}-group"
}

resource "rafay_groupassociation" "groupassociation" {
  depends_on = [rafay_group.group]
  project = "${var.project}"
  group = "${local.namespace}-group"
  namespaces = ["${local.namespace}"]
  roles = ["NAMESPACE_ADMIN"]
  add_users = ["${var.username}"]
  idp_user = var.user_type
}
