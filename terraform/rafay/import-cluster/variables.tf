variable "cluster_name" {
  type    = string
  default = "rafay-digitalocean-k8s"
}

variable "blueprint" {
  type    = string
  default = "minimal"
}

variable "location" {
  type    = string
  default = "sanjose-us"
}

variable "projectname" {
  type    = string
  default = "defaultproject"
}

variable "kube_config" {
  type = string
}
