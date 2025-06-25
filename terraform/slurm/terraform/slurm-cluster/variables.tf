variable "namespace" {
  type = string
}

variable "projectid" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "storageclass" {
  type = string
}

variable "kubeconfig_url" {
  description = "URL to the kubeconfig file"
}

variable "rctl_config_path" {
  description = "The path to the Rafay CLI config file"
  type        = string
  default     = "opt/rafay"
}
