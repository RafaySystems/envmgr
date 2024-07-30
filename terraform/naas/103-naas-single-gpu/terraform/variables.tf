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
  default = "single_gpu"
}

variable "namespace_quotas" {
  default = {
    single_gpu = {
      cpu_requests    = "26000m"
      memory_requests = "234Gi"
      cpu_limits      = "26000m"
      memory_limits   = "234Gi"
      gpu_requests    = "1"
      gpu_limits      = "1"
    }
  }
}

variable "group" {
  type = string
}

variable "user" {
  type = string
}
