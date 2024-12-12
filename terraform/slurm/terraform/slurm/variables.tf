variable "namespace" {
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