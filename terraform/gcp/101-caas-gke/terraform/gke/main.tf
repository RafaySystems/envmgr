resource "random_integer" "networkbit" {
  min = 1
  max = 4095
}


resource "rafay_gke_cluster" "tf-example" {
  metadata {
    name    = var.cluster_name
    project = var.project_name
  }
  spec {
    type = "gke"
    blueprint {
      name    = var.blueprint
      version = var.blueprint_version
    }
    cloud_credentials = var.credentials_name
    config {
      gcp_project           = var.gcp_project
      control_plane_version = var.k8s_version
      location {
        type = "zonal"
        config {
          zone = var.zone
        }
      }
      network {
        name                     = var.network
        subnet_name              = var.subnet
        enable_vpc_nativetraffic = "true"
        max_pods_per_node        = 110
        access {
          type = "private"
          config {
            #ontrol_plane_ip_range                  = var.control_plane_ip_range
            control_plane_ip_range                  = cidrsubnet(var.control_plane_ip_range, 12, random_integer.networkbit.result)
            enable_access_control_plane_external_ip = true
          }
        }
      }
      features {
        enable_compute_engine_persistent_disk_csi_driver = "true"
      }
      dynamic "node_pools" {
        for_each = var.node_pools
        content {
          name         = node_pools.value.name
          node_version = node_pools.value.node_version
          size         = node_pools.value.node_size
          machine_config {
            machine_type   = node_pools.value.machine_type
            image_type     = "COS_CONTAINERD"
            boot_disk_type = "pd-standard"
            boot_disk_size = 100
          }
          auto_scaling {
            max_nodes = node_pools.value.max_nodes
            min_nodes = node_pools.value.min_nodes
          }
        }
      }
    }
  }
}
