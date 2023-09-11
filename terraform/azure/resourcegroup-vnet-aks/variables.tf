variable "resource_group_name" {
  description = "Resource Group name"
  type = string
}

variable "resource_group_location" {
  description = "Resource Group location"
  type = string
}

variable "vnet_name" {
  description = "Virtual Network name"
  type = string
}
variable "vnet_address_space" {
  description = "Virtual Network address_space"
  type = list(string)
  default = ["10.0.0.0/8"]
}

variable "k8s_subnet_name" {
  description = "Virtual Network K8s Subnet Name"
  type = string
}

variable "k8s_subnet_address" {
  description = "Virtual Network Web Subnet Address Spaces"
  type = list(string)
  default = ["10.0.0.0/16"]
}

variable "project" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "blueprint_name" {
  type = string
}

variable "blueprint_version" {
  type = string
}

variable "cloud_credentials_name" {
  type = string
}

variable "k8s_version" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "app_namespace" {
  type = string
}

variable "app_name" {
  type = string
}

variable "argo_server" {
  type = string
}

variable "argo_username" {
  type = string
}

variable "argo_password" {
  type = string
}