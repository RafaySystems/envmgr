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
		config_maps = "10"
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
		storage_requests = "1Gi"
	}
    network_policy_params {
            network_policy_enabled = true
            policies {
                name    = var.network_policy_name
                version = var.network_policy_version
            }
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


resource "rafay_groupassociation" "groupassociation_collaborators" {
  count = var.collaborator == "user_email" ? 0 : 1
  depends_on = [rafay_groupassociation.groupassociation]
  project = "${var.project}"
  roles = ["NAMESPACE_ADMIN"]
  group = "${local.namespace}-group"
  namespaces = ["${local.namespace}"]
  add_users = ["${var.collaborator}"]
  idp_user = true
}
