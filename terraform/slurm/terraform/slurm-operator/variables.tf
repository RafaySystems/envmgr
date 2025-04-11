variable "cluster_name" {
  type = string
}

variable "kubeconfig_path" {
  description = "Path to the Kubernetes config file"
  default     = "kubeconfig.json"
}

variable "rctl_config_path" {
  description = "The path to the Rafay CLI config file"
  type        = string
}
