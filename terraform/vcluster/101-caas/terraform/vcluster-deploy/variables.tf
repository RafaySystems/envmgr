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
