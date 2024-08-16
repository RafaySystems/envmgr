  variable "node_pools" {
  description = "Node pool configuration"
  type = map(object({
    name           = string
    node_count     = number
    version        = string
    node_locations = list(string)
    machine_type   = string
    image_type     = string
    disk_size      = optional(number)
    disk_type      = optional(string)
    labels         = optional(map(string))
    tags           = optional(list(string))
    placement_policy = optional(object({
      policy_name = string
      type        = string
    }))
    host_maintenance_policy = optional(object({
      maintenance_interval = string
    }))
    ephemeral_storage_local_ssd_config = optional(object({
      local_ssd_count = number
    }))
    taints = optional(object({
      key    = string
      value  = string
      effect = string
    }))
    guest_accelerator = optional(object({
      gpu_type  = string
      gpu_count = number
    }))
    reservation_affinity = optional(object({
      consume_reservation_type = string
      key                      = optional(string)
      values                   = optional(list(string))
    }))
    additional_node_network_configs = optional(object({
      network    = optional(string)
      subnetwork = optional(string)
    }))
  }))
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "CIDR block to use for k8s master"
  default     = "172.16.0.0/28"
}

variable "google_project" {
  type        = string
  description = "Google project ID"
}

variable "location" {
  type        = string
  description = "Name of the location where GKE cluster will be created"
  default     = "us-central1-a"
}

variable "network" {
  type        = string
  description = "Name of the network where GKE cluster will be created"
  default     = "default"
}

variable "subnetwork" {
  type        = string
  description = "Name of the subnetwork where GKE cluster will be created"
  default     = "default"
}

variable "k8s_version" {
  type        = string
  description = "Kubernetes Version"
  default     = "1.27.3"
}

variable "node_locations" {
  type        = list(string)
  description = "List of the node locations where GKE cluster will be created"
  default     = ["us-central1-a"]
}

variable "release_channel" {
  type        = string
  description = "Kubernetes Release channel"
  default     = "STABLE"
}

variable "master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
  default     = []
}


variable "enable_private_endpoint" {
  type        = bool
  description = "Use Internal IP for the cluster endpoint"
  default     = false
}

variable "ip_allocation_policy" {
  type        = object({ cluster_secondary_range_name = optional(string), services_secondary_range_name = optional(string) })
  description = "Name of the secondary address range to use for Pods and Services"
  default     = {}
}

variable "network_policy" {
  type        = object({ enabled = optional(bool), provider = optional(string) })
  description = "Network Policy Config"
  default     = { enabled = false, provider = "PROVIDER_UNSPECIFIED" }
}

variable "network_policy_config" {
  type        = object({ disabled = optional(bool) })
  description = "Network Policy Config"
  default     = { disabled = true }
}


variable "cluster_name" {}
variable "project_name" {}
variable "blueprint" {}
variable "blueprint_version" {}
variable "username" {}
variable "shared_project_name" {}

variable "additional_node_network_configs" {
  description = "GPU Network configuration"
  type = map(object({
    network    = string
    subnetwork = string
  }))
}

variable "enable_multi_networking" {
  type        = bool
  description = "Enable Multi Networking"
  default     = true
}

variable "datapath_provider" {
  type        = string
  description = "Datapath Provider type"
  default     = "ADVANCED_DATAPATH"
}


variable "storage_classes" {
  type = map(object({
    tier = string
  }))
  default = {
    "nvidia-standard-rwx" = {
      tier = "standard"
    }
    "nvidia-premium-rwx" = {
      tier = "premium"
    }
    "nvidia-enterprise-rwx" = {
      tier = "enterprise"
    }
  }

}

  variable "rafay_rest_endpoint" {
    default = "nvidia-admin.rafay.dev"
  }