/****************************
Azure Resource Group Variables
****************************/

variable "existing_resource_group_name" {
  description = "The name of an existing resource group the Kubernetes cluster should be deployed into. Defaults to the name of the cluster + `-rg` if none is specified"
  default     = null
  type        = string
}

variable "location" {
  description = "The region to create resources in"
}

/****************************
AKS Variables
****************************/

variable "cluster_name" {
  default     = "aks-cluster"
  description = "The name of the AKS Cluster to be created"
}

variable "kubernetes_version" {
  default     = "1.28"
  description = "Version of Kubernetes to turn on. Run 'az aks get-versions --location <location> --output table' to view all available versions "
}

variable "cpu_node_pool_disk_size" {
  description = "Disk size in GB of nodes in the Default GPU pool"
  default     = 100
}

variable "cpu_node_pool_count" {
  description = "Count of nodes in Default GPU pool"
  default     = 1
}

variable "cpu_node_pool_min_count" {
  description = "Min ount of number of nodes in Default CPU pool"
  default     = 1
}
variable "cpu_node_pool_max_count" {
  description = "Max count of nodes in Default CPU pool"
  default     = 5
}
variable "cpu_machine_type" {
  default     = "Standard_D16_v5"
  description = "Machine instance type of the AKS CPU node pool"
}
variable "cpu_os_sku" {
  description = "Specifies the OS SKU used by the agent pool. Possible values include: Ubuntu, CBLMariner, Mariner, Windows2019, Windows2022"
  default     = "Ubuntu"
}

/****************************
GPU Node Pool Variables
****************************/
variable "gpu_node_pool_disk_size" {
  description = "Disk size in GB of nodes in the Default GPU pool"
  default     = 100
}
variable "gpu_node_pool_count" {
  description = "Count of nodes in Default GPU pool"
  default     = 2
}
variable "gpu_node_pool_min_count" {
  description = "Min count of number of nodes in Default GPU pool"
  default     = 2
}
variable "gpu_node_pool_max_count" {
  description = "Max count of nodes in Default GPU pool"
  default     = 5
}
variable "gpu_machine_type" {
  default     = "Standard_NC6s_v3"
  description = "Machine instance type of the AKS GPU node pool"
}
variable "gpu_os_sku" {
  description = "Specifies the OS SKU used by the agent pool. Possible values include: Ubuntu, CBLMariner, Mariner, Windows2019, Windows2022"
  default     = "Ubuntu"
}
/****************************
GPU Operator Variables
****************************/
variable "gpu_operator_version" {
  default     = "v23.9.1"
  description = "Version of the GPU operator to be installed"
}

variable "gpu_operator_namespace" {
  type        = string
  default     = "gpu-operator"
  description = "The namespace to deploy the NVIDIA GPU operator into"
}

variable "nvaie" {
  type        = bool
  default     = false
  description = "To use the versions of GPU operator and drivers specified as part of NVIDIA AI Enterprise, set this to true. More information at https://www.nvidia.com/en-us/data-center/products/ai-enterprise"
}

variable "nvaie_gpu_operator_version" {
  type        = string
  default     = "v23.9.0"
  description = "The NVIDIA Driver version of GPU Operator. Overrides `gpu_operator_version` when `nvaie` is set to `true`"
}

variable "node_pool_size" {
  description = "Node pool size, ex: small, medium, large, xlarge"
  type = string
}

variable "node_pool_config" {
  description = "Node pool configuration"
  type = map(object({
    name          = string
    cpu_node_count     = number
    cpu_node_pool_max_count = number
    cpu_node_pool_min_count = number
    cpu_os_sku   = string
    version = string
    cpu_machine_type = string
    gpu_machine_type = string
    cpu_node_pool_disk_size    = optional(number)
    gpu_node_pool_disk_size    = optional(number)
    gpu_node_count     = number
    gpu_node_pool_max_count = number
    gpu_node_pool_min_count = number
    gpu_os_sku   = string
  }))
}

variable "project_name" {
  description = "Rafay Project Name"
  type = string
}
variable "aks_blueprint" {
  description = "Rafay blueprint Name"
  type = string
}
variable "aks_blueprint_version" {
  description = "Rafay blueprint Version"
  type = string
}
variable "cloud_provider" {
  description = "Name of the cloud provider, ex: aws,azure,gcp,oci,etc"
  type = string
}