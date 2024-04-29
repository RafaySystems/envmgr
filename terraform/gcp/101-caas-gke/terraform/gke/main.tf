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
        #type = var.region != "" ? "regional" : "zonal"
        type = "zonal"
        config {
          #region = try(var.region, null)
          zone = var.zone
        }
      }
      security {
        enable_google_groups_for_rbac = try(var.enable_google_groups_for_rbac, null)
        enable_legacy_authorization   = var.enable_legacy_authorization
        enable_workload_identity      = var.enable_workload_identity
        issue_client_certificate      = var.issue_client_certificate
      }
      network {
        name                         = var.network
        subnet_name                  = var.subnet
        enable_vpc_nativetraffic     = var.enable_vpc_nativetraffic
        max_pods_per_node            = var.max_pods_per_node
        pod_address_range            = try(var.pod_address_range, null)
        service_address_range        = try(var.service_address_range, null)
        pod_secondary_range_name     = try(var.pod_secondary_range_name, null)
        service_secondary_range_name = try(var.service_secondary_range_name, null)

        access {
          type = var.access_type
          config {
            control_plane_ip_range                  = cidrsubnet(var.control_plane_ip_range, 12, random_integer.networkbit.result)
            enable_access_control_plane_external_ip = true
          }
        }
      }
      features {
        enable_compute_engine_persistent_disk_csi_driver = var.enable_compute_engine_persistent_disk_csi_driver ? true : false
        enable_filestore_csi_driver                      = var.enable_filestore_csi_driver ? true : false
        enable_application_manager_beta                  = var.enable_application_manager_beta ? true : false
        enable_backup_for_gke                            = var.enable_backup_for_gke ? true : false
        enable_image_streaming                           = var.enable_image_streaming ? true : false
        enable_managed_service_prometheus                = var.enable_managed_service_prometheus ? true : false
        enable_cloud_logging                             = var.enable_cloud_logging ? true : false
        cloud_logging_components                         = var.enable_cloud_logging ? var.cloud_logging_components : null
        enable_cloud_monitoring                          = var.enable_cloud_monitoring ? true : false
        cloud_monitoring_components                      = var.enable_cloud_monitoring ? var.cloud_monitoring_components : null


      }
      dynamic "node_pools" {
        for_each = var.node_pools
        content {
          name         = node_pools.value.name
          node_version = node_pools.value.node_version
          size         = node_pools.value.node_size
          machine_config {
            machine_type   = node_pools.value.machine_type
            image_type     = node_pools.value.image_type
            boot_disk_type = node_pools.value.disk_type
            boot_disk_size = node_pools.value.disk_size
          }
          auto_scaling {
            max_nodes = node_pools.value.max_nodes
            min_nodes = node_pools.value.min_nodes
          }
          networking {
            max_pods_per_node = node_pools.value.max_pods_per_node
            network_tags      = try(node_pools.value.network_tags, null)

          }
          metadata {
            dynamic "kubernetes_labels" {
              for_each = node_pools.value.kubernetes_labels == null ? {} : node_pools.value.kubernetes_labels
              content {
                key   = kubernetes_labels.key
                value = kubernetes_labels.value
              }
            }
            dynamic "node_taints" {
              for_each = node_pools.value.node_taints == null ? [] : [node_pools.value.node_taints]
              content {
                effect = node_taints.value.effect
                key    = node_taints.value.key
                value  = node_taints.value.value
              }
            }
          }
        }
      }
    }
  }
}
