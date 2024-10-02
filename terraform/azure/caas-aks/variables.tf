variable "project" {
  type        = string
  description = "Rafay Project name"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "AKS Cluster name"

}

variable "blueprint_name" {
  type        = string
  description = "Rafay blueprint name"
  default     = "minimal"
}

variable "blueprint_version" {
  type        = string
  description = "Blueprint version"
  default     = "latest"
}

variable "cloud_credentials_name" {
  type        = string
  description = "Rafay Cloud Credentials name"
  default     = ""
}

variable "cluster_resource_group" {
  type        = string
  description = "Azure Resource Group name"
}

variable "location" {
  type        = string
  description = "Azure location"
  default     = "centralindia"
}

variable "k8s_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.29.0"
}

variable "cluster_labels" {
  type        = map(string)
  description = "Cluster Labels"
  default = {
    "provisioned-by" = "rafay"
  }
}

variable "tags" {
  type        = map(string)
  description = "Cluster Tags"
  default = {
    "env"   = "qa"
  }
}

variable "authorized_ip_ranges" {
  type    = list(string)
  default = []

}

variable "enable_private_cluster" {
  type    = bool
  default = true
}

variable "enable_private_cluster_public_fqdn" {
  type    = bool
  default = false
}

variable "private_dns_zone" {
  type        = string
  description = "Private Dns Zone"
  default     = ""
}

variable "identity" {
  type        = string
  description = "Cluster Identity Type"
  default     = "SystemAssigned"
}

variable "user_assigned_identities" {
  type        = string
  description = "User Assigned Identity"
  default     = ""
}

variable "network_profile" {
  type = map(string)
  default = {
    "network_plugin"      = "kubelet"
    "network_policy"      = "calico"
    "outbound_type"       = "loadBalancer"
    "load_balancer_sku"   = null ## Possible values are basic & standard
    "output_type"         = null ## Possible values are loadbalancer & userDefineRouting
    "network_plugin_mode" = null ##Possible value overlay
    "docker_bridge_cidr"  = null ##Required when network_plugin = azure
    "dns_service_ip"      = "10.0.0.10"
    "service_cidr"        = "10.0.0.0/16"
    "pod_cidr"            = "10.244.0.0/16"

  }
}

variable "node_pools" {
  type = map(object({
    name                = string
    location            = string
    count               = number
    max                 = number
    min                 = number
    vm_size             = string
    k8s_version         = string
    mode                = string
    os_type             = string
    os_sku              = string
    os_disk_size_gb     = number
    tags                = map(string)
    node_labels         = map(string)
    node_taints         = list(string)
    vnet_subnet_id      = string
    enable_auto_scaling = bool
  }))
}


variable "enabled_cluster_sharing" {
  type    = bool
  default = false
}

variable "enabled_cluster_sharing_all_projects" {
  type    = bool
  default = false

}

variable "shared_projects" {
  type    = list(string)
  default = []
}
