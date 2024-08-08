variable "cluster_name" {
  type = string
}

variable "host_project" {
  type = string
}

variable "bootstrap_data" {
  type = string
}

variable "ns_name" {
  type = string
}

variable "host_cluster_name" {
  type = string
}

variable "filename" {
  type    = string
  default = "vcluster-values.yaml"
}

variable "default_charts" {
  description = "mapping for vcluster distro"
  default = {
    "k3s" = "vcluster",
    "k0s" = "vcluster-k0s",
    "k8s" = "vcluster-k8s"
    "eks" = "vcluster-eks"
  }
}

variable "distro" {
  type    = string
  default = "k3s"

}

variable "repository" {
  type    = string
  default = "rafay-vcluster-loft"
}

variable "namespace_quota_size" {
  type    = string
  default = "single_gpu"
}

variable "namespace_quotas" {
  default = {
    single_gpu = {
      cpu_requests    = "3000m"
      memory_requests = "33Gi"
      cpu_limits      = "6000m"
      memory_limits   = "33Gi"
      gpu_requests    = "1"
      gpu_limits      = "1"
    }
    two_gpus = {
      cpu_requests    = "6000m"
      memory_requests = "66Gi"
      cpu_limits      = "6000m"
      memory_limits   = "66Gi"
      gpu_requests    = "2"
      gpu_limits      = "2"
    }
    three_gpus = {
      cpu_requests    = "9000m"
      memory_requests = "99Gi"
      cpu_limits      = "9000m"
      memory_limits   = "99Gi"
      gpu_requests    = "3"
      gpu_limits      = "3"
    }
    four_gpus = {
      cpu_requests    = "12000m"
      memory_requests = "132Gi"
      cpu_limits      = "12000m"
      memory_limits   = "132Gi"
      gpu_requests    = "4"
      gpu_limits      = "4"
    }
    five_gpus = {
      cpu_requests    = "15000m"
      memory_requests = "165Gi"
      cpu_limits      = "15000m"
      memory_limits   = "165Gi"
      gpu_requests    = "5"
      gpu_limits      = "5"
    }
    six_gpus = {
      cpu_requests    = "18000m"
      memory_requests = "198Gi"
      cpu_limits      = "18000m"
      memory_limits   = "198Gi"
      gpu_requests    = "6"
      gpu_limits      = "6"
    }
    seven_gpus = {
      cpu_requests    = "21000m"
      memory_requests = "231Gi"
      cpu_limits      = "21000m"
      memory_limits   = "231Gi"
      gpu_requests    = "7"
      gpu_limits      = "7"
    }
  }
}
