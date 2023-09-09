resource "rafay_aks_cluster" "aks-cluster" {
  apiversion = "rafay.io/v1alpha1"
  kind       = "Cluster"
  metadata {
    name    = var.cluster_name
    project = var.project
  }
  spec {
    type          = "aks"
    blueprint     = var.blueprint_name
    blueprintversion = var.blueprint_version
    cloudprovider = var.cloud_credentials_name
    cluster_config {
      apiversion = "rafay.io/v1alpha1"
      kind       = "aksClusterConfig"
      metadata {
        name = var.cluster_name
      }
      spec {
        resource_group_name = azurerm_resource_group.rg.name
        managed_cluster {
          apiversion = "2021-05-01"
          identity {
            type = "UserAssigned"
             user_assigned_identities = {
                "${azurerm_user_assigned_identity.aks_identity.id}": "{}"
                }
          }
          sku {
            name = "Basic"
            tier = "Free"
          }
          location = var.resource_group_location
          properties {
            api_server_access_profile {
              enable_private_cluster = true
              enable_private_cluster_public_fqdn = false
              private_dns_zone  = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{dnsZoneName}"
            }
            dns_prefix          = var.cluster_name
            enable_rbac        = true
            kubernetes_version  = var.k8s_version
            node_resource_group = var.cluster_name
            network_profile {
              network_plugin = "kubenet"
              network_policy = "calico"
              outbound_type  = "loadBalancer"
            }
            auto_scaler_profile {
              balance_similar_node_groups      = "false"
              expander                         = "random"
              max_graceful_termination_sec     = "600"
              max_node_provision_time          = "15m"
              ok_total_unready_count           =  "3"
              max_total_unready_percentage     = "45"
              new_pod_scale_up_delay           = "10s"
              scale_down_delay_after_add       = "10m"
              scale_down_delay_after_delete    = "60s"
              scale_down_delay_after_failure   = "3m"
              scan_interval                    = "10s"
              scale_down_unneeded_time         = "10m"
              scale_down_unready_time          = "20m"
              scale_down_utilization_threshold = "0.5"
              max_empty_bulk_delete            = "10"
              skip_nodes_with_local_storage    = "true"
              skip_nodes_with_system_pods      = "true"
            }
          }
          type = "Microsoft.ContainerService/managedClusters"
           tags = {
            "env" = "demo"
          }
        }
        node_pools {
          apiversion = "2021-05-01"
          name       = "primary"
          properties {
            count                 = 2
            enable_auto_scaling   = true
            max_count             = 2
            max_pods              = 40
            min_count             = 1
            mode                  = "System"
            orchestrator_version  = var.k8s_version
            os_type               = "Linux"
            os_disk_size_gb       = 30
            type                  = "VirtualMachineScaleSets"
            availability_zones    = [1, 2, 3]
            enable_node_public_ip = false
            vm_size = var.vm_size
            vnet_subnet_id = azurerm_subnet.k8ssubnet.id
            node_labels = {
              "env" = "demo"
            }
            tags = {
              "env" = "demo"
            }
          }
          type = "Microsoft.ContainerService/managedClusters/agentPools"
          location = var.resource_group_location
        }
      }
    }
  }
}
