locals {
  master_authorized_networks_config = length(var.master_authorized_networks) == 0 ? [] : [{
    cidr_blocks : var.master_authorized_networks
  }]
}

resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  project                  = var.google_project
  location                 = var.location
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.network
  subnetwork               = var.subnetwork
  networking_mode          = "VPC_NATIVE"
  min_master_version	   = var.k8s_version
  deletion_protection      = false
  node_locations = var.node_locations

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = var.release_channel
  }


  dynamic ip_allocation_policy {
     for_each = var.ip_allocation_policy == null ? [] : [var.ip_allocation_policy]
     iterator = res
     content {
        cluster_secondary_range_name  = lookup(res.value, "cluster_secondary_range_name", null)
        services_secondary_range_name = lookup(res.value, "services_secondary_range_name", null)
      }
   }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  dynamic "master_authorized_networks_config" {
    for_each = local.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }

}


resource "google_container_node_pool" "np" {
  for_each = var.node_pools

  name       = each.value.name
  cluster    = google_container_cluster.primary.id
  project                  = "kr-test-200723"
  node_count = each.value.node_count
  version    = each.value.version
  node_locations =  each.value.node_locations
  node_config {
    image_type   = each.value.image_type
    machine_type = each.value.machine_type
    disk_size_gb  = lookup(each.value, "disk_size", 100)
    disk_type  = lookup(each.value, "disk_type", "pd-standard")
    labels = each.value.labels == null ? {} :  each.value.labels
    tags = each.value.tags == null ? [] :  each.value.tags
    dynamic "taint" {
      for_each = each.value.taints == null ? [] : [each.value.taints]
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }
    dynamic guest_accelerator {
      for_each = each.value.guest_accelerator == null ? [] : [each.value.guest_accelerator]
      iterator = gpu
      content {
        type  = lookup(gpu.value, "gpu_type", null)
        count = lookup(gpu.value, "gpu_count", null)
      }
    }
   dynamic reservation_affinity {
     for_each = each.value.reservation_affinity == null ? [] : [each.value.reservation_affinity]
     iterator = res
     content {
        consume_reservation_type  = lookup(res.value, "consume_reservation_type", null)
        key = lookup(res.value, "key", null)
        values = lookup(res.value, "values", null)
      }
   }
  }

}

data "google_client_config" "current" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.primary.endpoint}"
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}


resource "rafay_import_cluster" "gke" {
  clustername           = var.cluster_name
  projectname           = var.project_name
  blueprint             = var.blueprint
  blueprint_version     = var.blueprint_version
  kubernetes_provider   = "GKE"
  provision_environment = "CLOUD"
  values_path           = "values.yaml"
  depends_on 	= [google_container_node_pool.np]
}

resource "helm_release" "rafay_operator" {
  name       = "v2-infra"
  namespace = "rafay-system"
  create_namespace = true
  repository = "https://rafaysystems.github.io/rafay-helm-charts/"
  chart      = "v2-infra"

  values = [rafay_import_cluster.gke.values_data]
  lifecycle {
    ignore_changes = [
      version
    ]
  }
}
