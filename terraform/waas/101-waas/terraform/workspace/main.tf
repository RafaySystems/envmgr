resource "random_id" "rnd" {
  keepers = {
    first = var.cluster_name
  }
  byte_length = 4
}

locals {
  # Create a unique workspace name
  workspace1 = "${element(split("@",var.username),0)}-${random_id.rnd.dec}"
  workspace2 = replace(local.workspace1,"+","-")
  workspace3 = replace(local.workspace2,".","-")
  workspace4 = replace(local.workspace3,"+","-")
  workspace = lower(local.workspace4)
}

resource "rafay_project" "workspace_project" {
  metadata {
    name        = local.workspace
  }
  spec {
    default = false
    cluster_resource_quota {
      cpu_requests = var.cpu
      memory_requests = var.memory
      cpu_limits = "8000m"
      memory_limits = "8192Mi"
      config_maps = "10"
      persistent_volume_claims = "5"
      services = "20"    
      pods = "200"
      replication_controllers = "10"
      services_load_balancers = "10"
      services_node_ports = "10"
      storage_requests = "100Gi"
    }
    default_cluster_namespace_quota {
      cpu_requests = "1000m"
      memory_requests = "1024Mi"
      cpu_limits = "2000m"
      memory_limits = "2048Mi"
      config_maps = "5"
      persistent_volume_claims = "2"
      services = "10"
      pods = "20"
      replication_controllers = "4"
      services_load_balancers = "4"
      services_node_ports = "4"
      storage_requests = "10Gi"
    }
  }
}

resource "rafay_group" "group" {
  name        = "${local.workspace}-group"
}

resource "rafay_groupassociation" "groupassociation" {
  depends_on = [rafay_group.group]
  project = "${local.workspace}"
  group = "${local.workspace}-group"
  roles = ["WORKSPACE_ADMIN"]
  add_users = ["${var.username}"]
  idp_user = var.user_type
}

resource "rafay_cluster_sharing" "share_cluster" {
  clustername = var.cluster_name
  project     = var.project
  sharing {
    all = false
    projects {
      name = local.workspace
    }
  }
}

resource "rafay_groupassociation" "groupassociation_collaborators" {
  count = var.collaborator == "user_email" ? 0 : 1
  depends_on = [rafay_groupassociation.groupassociation]
  project = "${local.workspace}"
  roles = ["WORKSPACE_ADMIN"]
  group = "${local.workspace}-group"
  add_users = ["${var.collaborator}"]
  idp_user = true
}
