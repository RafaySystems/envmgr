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

variable "hserver" {
  description = "Kubeconfig server"
  type        = string
}

variable "clientcertificatedata" {
  description = "Kubeconfig client-certificate-data"
  type        = string
}

variable "clientkeydata" {
  description = "Kubeconfig client-key-data"
  type        = string
}

variable "certificateauthoritydata" {
  description = "Kubeconfig certificate-authority-data"
  type        = string
}

variable "rctl_config_path" {
  description = "The path to the Rafay CLI config file"
  type        = string
  default     = "opt/rafay"
}
