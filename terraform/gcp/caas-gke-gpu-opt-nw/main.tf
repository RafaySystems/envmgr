locals {
  master_authorized_networks_config = length(var.master_authorized_networks) == 0 ? [] : [{
    cidr_blocks : var.master_authorized_networks
  }]
}

resource "random_integer" "priority" {
  min = 1
  max = 250
}

resource "google_container_cluster" "primary" {
  provider                 = google-beta
  name                     = var.cluster_name
  project                  = var.google_project
  location                 = var.location
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.network
  subnetwork               = var.subnetwork
  networking_mode          = "VPC_NATIVE"
  min_master_version       = var.k8s_version
  deletion_protection      = false
  node_locations           = var.node_locations
  enable_multi_networking  = var.enable_multi_networking
  datapath_provider        = var.datapath_provider
  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    dynamic "network_policy_config" {
      for_each = var.network_policy_config == null ? [] : [var.network_policy_config]
      content {
        disabled = lookup(network_policy_config.value, "disabled", true)
      }
    }
    gcp_filestore_csi_driver_config {
      enabled = true
    }
  }

  release_channel {
    channel = var.release_channel
  }


  dynamic "ip_allocation_policy" {
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
    master_ipv4_cidr_block  = "172.16.${random_integer.priority.result}.0/28"
  }
  dynamic "network_policy" {
    for_each = var.network_policy == null ? [] : [var.network_policy]
    content {
      enabled  = lookup(network_policy.value, "enabled", false)
      provider = lookup(network_policy.value, "provider", "")
    }
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
  provider = google-beta
  for_each = var.node_pools

  name           = each.value.name
  cluster        = google_container_cluster.primary.id
  project        = var.google_project
  node_count     = each.value.node_count
  version        = each.value.version
  node_locations = each.value.node_locations
  dynamic "placement_policy" {
    for_each = each.value.placement_policy == null ? [] : [each.value.placement_policy]
    iterator = policy
    content {
      policy_name = lookup(policy.value, "policy_name", null)
      type        = lookup(policy.value, "type", null)
    }
  }
  network_config {
    enable_private_nodes = true
    dynamic "additional_node_network_configs" {
      for_each = var.additional_node_network_configs
      content {
        network    = additional_node_network_configs.value.network
        subnetwork = additional_node_network_configs.value.subnetwork
      }
    }
  }
  node_config {
    dynamic "host_maintenance_policy" {
      for_each = each.value.host_maintenance_policy == null ? [] : [each.value.host_maintenance_policy]
      iterator = hmp
      content {
        maintenance_interval = lookup(hmp.value, "maintenance_interval", null)
      }
    }
    image_type   = each.value.image_type
    machine_type = each.value.machine_type
    disk_size_gb = lookup(each.value, "disk_size", 100)
    disk_type    = lookup(each.value, "disk_type", "pd-standard")
    labels       = each.value.labels == null ? {} : each.value.labels
    tags         = each.value.tags == null ? [] : each.value.tags
    dynamic "ephemeral_storage_local_ssd_config" {
      for_each = each.value.ephemeral_storage_local_ssd_config == null ? [] : [each.value.ephemeral_storage_local_ssd_config]
      iterator = eph_storage
      content {
        local_ssd_count = lookup(eph_storage.value, "local_ssd_count", null)
      }
    }
    dynamic "taint" {
      for_each = each.value.taints == null ? [] : [each.value.taints]
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }
    dynamic "guest_accelerator" {
      for_each = each.value.guest_accelerator == null ? [] : [each.value.guest_accelerator]
      iterator = gpu
      content {
        type  = lookup(gpu.value, "gpu_type", null)
        count = lookup(gpu.value, "gpu_count", null)
      }
    }
    dynamic "reservation_affinity" {
      for_each = each.value.reservation_affinity == null ? [] : [each.value.reservation_affinity]
      iterator = res
      content {
        consume_reservation_type = lookup(res.value, "consume_reservation_type", null)
        key                      = lookup(res.value, "key", null)
        values                   = lookup(res.value, "values", null)
      }
    }
  }
  timeouts {
    create = "120m"
    update = "120m"
  }

}

data "google_client_config" "current" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
  /*exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command = "gke-gcloud-auth-plugin"
  }*/
}

provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.primary.endpoint}"
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.current.access_token
    /*exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command = "gke-gcloud-auth-plugin"
    }*/
  }
}

resource "rafay_access_apikey" "sampleuser" {
  user_name = var.username
}

resource "null_resource" "delete-webhook" {
  triggers = {
    cluster_name      = var.cluster_name
    rafay_rest_endpoint       = var.rafay_rest_endpoint
    project_name    = var.project_name
    rafay_api_key   = rafay_access_apikey.sampleuser.apikey
  }
  provisioner "local-exec" {
    when  = destroy
    command = "./delete-webhook.sh"
    environment = {
      CLUSTER_NAME        = "${self.triggers.cluster_name}"
      RAFAY_REST_ENDPOINT = "${self.triggers.rafay_rest_endpoint}"
      RAFAY_API_KEY       = "${self.triggers.rafay_api_key}"
      PROJECT             = "${self.triggers.project_name}"
    }
  }
  depends_on = [rafay_access_apikey.sampleuser,helm_release.rafay_operator]
}


resource "rafay_import_cluster" "gke" {
  clustername           = var.cluster_name
  projectname           = var.project_name
  blueprint             = var.blueprint
  blueprint_version     = var.blueprint_version
  kubernetes_provider   = "GKE"
  provision_environment = "CLOUD"
  values_path           = "values.yaml"
  depends_on            = [google_container_node_pool.np]
}

resource "helm_release" "rafay_operator" {
  name             = "v2-infra"
  namespace        = "rafay-system"
  create_namespace = true
  repository       = "https://rafaysystems.github.io/rafay-helm-charts/"
  chart            = "v2-infra"

  values = [rafay_import_cluster.gke.values_data]
  lifecycle {
    ignore_changes = [
      version
    ]
  }
}

resource "rafay_cluster_sharing" "cluster-sharing" {
  clustername = var.cluster_name
  project     = var.project_name
  sharing {
    all = false
    projects {
      name = var.shared_project_name
    }
  }
  depends_on = ["helm_release.rafay_operator"]
}

/*data "rafay_download_kubeconfig" "kubeconfig_cluster" {
  username = var.username
  depends_on = [helm_release.rafay_operator]
}



output "kubeconfig_cluster" {
  description = "kubeconfig_cluster"
  value       = data.rafay_download_kubeconfig.kubeconfig_cluster.kubeconfig
}*/

resource "kubernetes_storage_class" "filestore" {
  for_each = {
    for k, v in var.storage_classes : k => v
  }
  metadata {
    name = each.key
  }
  storage_provisioner = "filestore.csi.storage.gke.io"
  reclaim_policy      = "Delete"
  parameters = {
    tier    = each.value.tier
    network = var.network
  }
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
  depends_on             = [google_container_node_pool.np]
}
