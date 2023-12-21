variable "project_name" {
  type = string
}

variable "control_plane_ip" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cloud_credentials" {
  type = string
}

variable "k8s_version" {
  type = string
  default = "v1.28.0"
}

variable "vm_template" {
  type = string
  default = "ubuntu-2004-kube-v1.28.0"
}

variable "vsphere_resource_pool" {
  type = string
}

variable "vsphere_datacenter" {
  type = string
}

variable "vsphere_datastore" {
  type = string
}

variable "vsphere_network" {
  type = string
}
