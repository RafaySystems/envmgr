variable "namespace" {
  type = string
}

variable "projectid" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "install_slurm_operator" {
  type    = bool
  default = true
}

variable "install_slurm_cluster" {
  type    = bool
  default = true
}

variable "kubeconfig_path" {
  description = "Path to the Kubernetes config file"
  default     = "kubeconfig.json"
}

variable "rctl_config_path" {
  description = "The path to the Rafay CLI config file"
  type        = string
}
