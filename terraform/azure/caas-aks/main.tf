resource "rafay_aks_cluster_v3" "cluster" {
  metadata {
    name    = var.cluster_name
    project = var.project
    labels  = var.cluster_labels
  }
  spec {
    type = "aks"
    blueprint_config {
      name    = var.blueprint_name
      version = var.blueprint_version
    }
    cloud_credentials = var.cloud_credentials_name
    config {
      kind = "aksClusterConfig"
      metadata {
        name = var.cluster_name
      }
      spec {
        resource_group_name = var.cluster_resource_group
        managed_cluster {
          api_version = "2024-01-01"
          identity {
            type = var.identity
            user_assigned_identities = var.user_assigned_identities != "" ? {
              var.user_assigned_identities : "{}"
            } : null
          }
          location = var.location
          properties {
            api_server_access_profile {
              authorized_ip_ranges               = length(var.authorized_ip_ranges) > 0 ? var.authorized_ip_ranges : null
              enable_private_cluster             = var.enable_private_cluster
              enable_private_cluster_public_fqdn = var.enable_private_cluster_public_fqdn
              private_dns_zone                   = var.private_dns_zone != "" ? var.private_dns_zone : null
            }
            dns_prefix         = "${var.cluster_name}-dns"
            enable_rbac        = true
            kubernetes_version = var.k8s_version
            network_profile {
              network_plugin      = var.network_profile["network_plugin"]
              network_policy      = try(var.network_profile["network_policy"], null)
              outbound_type       = try(var.network_profile["outbound_type"], null)
              network_plugin_mode = try(var.network_profile["network_plugin_mode"], null)
              docker_bridge_cidr  = try(var.network_profile["docker_bridge_cidr"], null)
              dns_service_ip      = try(var.network_profile["dns_service_ip"], null)
              service_cidr        = try(var.network_profile["service_cidr"], null)
              pod_cidr            = try(var.network_profile["pod_cidr"], null)
            }
          }
          type = "Microsoft.ContainerService/managedClusters"
          tags = var.tags
        }
        dynamic "node_pools" {
          for_each = var.node_pools
          content {
            api_version = "2022-07-01"
            name        = node_pools.value.name
            location    = node_pools.value.location
            properties {
              count                = node_pools.value.count
              enable_auto_scaling  = node_pools.value.enable_auto_scaling
              max_count            = node_pools.value.max
              min_count            = node_pools.value.min
              max_pods             = 110
              mode                 = node_pools.value.mode
              orchestrator_version = node_pools.value.k8s_version != null ? node_pools.value.k8s_version : var.k8s_version
              os_type              = node_pools.value.os_type
              os_sku               = node_pools.value.os_sku
              os_disk_size_gb      = node_pools.value.os_disk_size_gb
              availability_zones   = try(node_pools.value.availability_zones, null)
              type                 = "VirtualMachineScaleSets"
              vm_size              = node_pools.value.vm_size
              tags                 = try(node_pools.value.tags, null)
              node_labels          = try(node_pools.value.node_labels, null)
              node_taints          = try(node_pools.value.node_taints, null)
              vnet_subnet_id       = try(node_pools.value.vnet_subnet_id, null)
            }
            type = "Microsoft.ContainerService/managedClusters/agentPools"
          }
        }
      }
    }
  }
}

resource "rafay_cluster_sharing" "demo-terraform-specific" {
  count       = var.enabled_cluster_sharing ? 1 : 0
  clustername = var.cluster_name
  project     = var.project
  sharing {
    all = var.enabled_cluster_sharing_all_projects
    dynamic "projects" {
      for_each = var.shared_projects
      content {
        name = projects.value
      }
    }
  }
}
