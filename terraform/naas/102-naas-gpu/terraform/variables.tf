variable "project" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "namespace" {
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
      gpu_requests             = ""
      gpu_limits               = ""
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
      gpu_requests             = ""
      gpu_limits               = ""
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
      gpu_requests             = ""
      gpu_limits               = ""
    }
    small_with_gpu = {
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
      gpu_requests             = "4"
      gpu_limits               = "4"
    }
    medium_with_gpu = {
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
      gpu_requests             = "8"
      gpu_limits               = "8"
    }
    large_with_gpu = {
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
      gpu_requests             = "16"
      gpu_limits               = "16"
    }
  }
}

variable "group" {
  type = string
}

variable "user" {
  type = string
}
