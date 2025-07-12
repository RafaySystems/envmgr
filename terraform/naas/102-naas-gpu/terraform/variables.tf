variable "project" {
  type = string
}

variable "projectid" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "annotations" {
  type    = map(string)
  default = {}
}

variable "namespace_quota_size" {
  type    = string
  default = "small"
}

variable "namespace_quotas" {
  default = {
    small = {
      cpu_requests             = "500m"
      memory_requests          = "1024Mi"
      cpu_limits               = "1000m"
      memory_limits            = "2048Mi"
      config_maps              = "5"
      persistent_volume_claims = "2"
      services                 = "5"
      pods                     = "25"
      replication_controllers  = "1"
      services_load_balancers  = "2"
      services_node_ports      = "2"
      storage_requests         = "50Gi"
      gpu_requests             = "1"
      gpu_limits               = "1"
    }
    medium = {
      cpu_requests             = "1000m"
      memory_requests          = "2048Mi"
      cpu_limits               = "2000m"
      memory_limits            = "4096Mi"
      config_maps              = "10"
      persistent_volume_claims = "4"
      services                 = "10"
      pods                     = "50"
      replication_controllers  = "2"
      services_load_balancers  = "4"
      services_node_ports      = "4"
      storage_requests         = "100Gi"
      gpu_requests             = "2"
      gpu_limits               = "2"
    }
    large = {
      cpu_requests             = "4000m"
      memory_requests          = "4096Mi"
      cpu_limits               = "8000m"
      memory_limits            = "8192Mi"
      config_maps              = "15"
      persistent_volume_claims = "8"
      services                 = "20"
      pods                     = "100"
      replication_controllers  = "4"
      services_load_balancers  = "8"
      services_node_ports      = "8"
      storage_requests         = "200Gi"
      gpu_requests             = "3"
      gpu_limits               = "3"
    }
  }
}

variable "username" {
  type = string
}
