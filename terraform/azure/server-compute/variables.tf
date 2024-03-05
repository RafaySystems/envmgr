variable "existing_resource_group_name" {
  description = "The name of an existing resource group the Kubernetes cluster should be deployed into. Defaults to the name of the cluster + `-rg` if none is specified"
  default     = null
  type        = string
}

variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "azureadmin"
}

variable "name" {
  type        = string
  description = "The name of the VM."
  default     = "demo"
}

variable "cloud_provider" {
  description = "Name of the cloud provider, ex: aws,azure,gcp,oci,etc"
  type = string
}

variable "ssh_public_key" {
  description = "SSH Public Key"
  type = string
}

variable "num_instances" {
  description = "no of instances to create"
  type = number
  default = 1
}

variable "security_group_ports" {
  description = "Security group ports to open"
  type = list(string)
}

variable instance_config {
  description = "Instance configuration"
  type = map(object({
    name          = string
    machine_type = string
    node_disk_size    = number
  }))
}

variable "instance_size" {
  description = "Instance size, ex: small, medium, large"
  type = string
  default = "small"
}