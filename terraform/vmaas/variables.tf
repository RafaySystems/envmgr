variable "vm_cpu" {
  description = "Number of CPUs per VM"
  type        = number
  default     = 4
}

variable "vm_memory" {
  description = "Amount of memory [GiB] per VM"
  type        = number
  default     = 16
}

variable "vm_disk_os_size" {
  description = "Minimum size of OS disk [GiB]"
  type        = number
  default     = 50
}

variable "vm_disk_data_size" {
  description = "Size of the DATA disk [GiB]"
  type        = number
  default     = 30
}

variable "vsphere_user" {
  description = "vSphere username for authentication"
  default     = "rafay"
}

variable "vsphere_password" {
  description = "vSphere password for authentication"
  sensitive   = true
}

variable "vm_username" {
  description = "VM username for authentication"
  default     = "ubuntu"
}

variable "vsphere_server" {
  description = "The vCenter server IP or FQDN"
  default     = "pcc-147-135-35-53.ovh.us"
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter to deploy virtual machines"
  default     = "pcc-147-135-35-53_datacenter1145"
}

variable "vsphere_compute_cluster" {
  description = "vSphere compute cluster where virtual machines will be created"
  default     = "Cluster1"
}

variable "vsphere_network" {
  description = "Network to connect the virtual machines within vSphere"
  default     = "rafay"
}

variable "vsphere_datastore" {
  description = "Datastore where virtual machines will reside"
  default     = "ssd-001858"
}

variable "vsphere_vm_template" {
  description = "Template name for creating virtual machines"
  default     = "ubuntutemplate1"
}

variable "vm_prefix" {
  description = "Prefix for virtual machine names"
  default     = "rafay-paas"
}

variable "vm_os" {
  description = "Operating system of VM for output"
  default     = "Ubuntu-22.04"
}

variable "vsphere_storage_policy" {
  description = "The vSphere storage policy. Set to empty string if not using a storage policy."
  type        = string
  default     = ""
}

variable "vsphere_resource_pool" {
  description = "The vSphere resource pool to use for VM deployment. Set to an empty string to use the default cluster resource pool."
  type        = string
  default     = "ovhServers"
}

variable "em_username" {
  description = "EM username"
  default     = "em_user"
}

variable "vm_ssh_public_key" {
  description = "Public SSH Key"
}

variable "vsphere_vm_folder" {
  description = "The vSphere folder to use for VM deployment. Set to an empty string to use the default cluster folder."
  type        = string
}

variable "vm_name" {
  description = "The name of the VM"
  type        = string
}

# variable "vm_password" {
#   description = "The password of the VM"
#   type        = string
#   sensitive   = true
# }

variable "vm_domain" {
  description = "The domain of the VM"
  type        = string
}
