variable "project_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "blueprint" {
  type    = string
  default = "default-gke"
}

variable "blueprint_version" {
  type    = string
  default = "latest"
}

variable "credentials_name" {
  type = string
}

## Requied for Regional cluster
# variable "region" {
#   type    = string
#   default = ""
# }

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "k8s_version" {
  type    = string
  default = "1.28"
}

variable "gcp_project" {
  type = string
}

variable "network" {
  type    = string
  default = "default"
}

variable "subnet" {
  type    = string
  default = "default"
}

variable "max_pods_per_node" {
  type    = number
  default = 110
}

variable "enable_vpc_nativetraffic" {
  type    = bool
  default = true

}

variable "pod_address_range" {
  type    = string
  default = ""
}

variable "service_address_range" {
  type    = string
  default = ""
}


variable "pod_secondary_range_name" {
  type    = string
  default = ""
}

variable "service_secondary_range_name" {
  type    = string
  default = ""
}

variable "node_pools" {
  type = map(object({
    name              = string
    node_size         = number
    max_nodes         = number
    min_nodes         = number
    node_version      = string
    machine_type      = string
    image_type        = string
    disk_size         = number
    disk_type         = string
    max_pods_per_node = number
    network_tags      = list(string)
    kubernetes_labels = optional(map(string))
    node_taints = optional(object({
      key    = string
      value  = string
      effect = string
    }))

  }))
  default = {
    "pool1" = {
      name              = "pool1"
      node_size         = 1
      min_nodes         = 1
      max_nodes         = 3
      node_version      = "1.28"
      machine_type      = "e2-standard-4"
      image_type        = "COS_CONTAINERD"
      disk_size         = 100
      disk_type         = "pd-standard"
      max_pods_per_node = 110
      network_tags      = null
      kubernetes_labels = { "managed-by" : "Rafay" }
    }
  }
}

variable "control_plane_ip_range" {
  type    = string
  default = "172.16.0.0/16"
}

## Valid values are `private` & `public`
variable "access_type" {
  type    = string
  default = "private"
}

## Set value to true if authorized_network is not empty.
variable "enabled_access" {
  type    = bool
  default = true
}

variable "enable_compute_engine_persistent_disk_csi_driver" {
  type    = bool
  default = true
}

## if set to true check value for `cloud_monitoring_components`
variable "enable_cloud_monitoring" {
  type    = bool
  default = false
}

## Update value as per requirements when `enable_cloud_monitoring` is set to true
variable "cloud_monitoring_components" {
  type    = list(string)
  default = ["SYSTEM_COMPONENTS"]
}

## if set to true check value for `cloud_logging_components`
variable "enable_cloud_logging" {
  type    = bool
  default = false
}

## Update value as per requirements when `enable_cloud_logging` is set to true
variable "cloud_logging_components" {
  type    = list(string)
  default = ["SYSTEM_COMPONENTS", "WORKLOADS"]
}

variable "enable_application_manager_beta" {
  type    = bool
  default = false
}

variable "enable_backup_for_gke" {
  type    = bool
  default = false
}

variable "enable_filestore_csi_driver" {
  type    = bool
  default = false
}

variable "enable_image_streaming" {
  type    = bool
  default = false
}

variable "enable_managed_service_prometheus" {
  type    = bool
  default = false
}

variable "enable_google_groups_for_rbac" {
  type    = bool
  default = false
}

variable "enable_legacy_authorization" {
  type    = bool
  default = false
}
variable "enable_workload_identity" {
  type    = bool
  default = false
}
variable "issue_client_certificate" {
  type    = bool
  default = false
}
