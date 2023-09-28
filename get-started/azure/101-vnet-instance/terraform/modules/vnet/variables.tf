variable "resource_group_name" {
  type        = string
  default     = "em-resource-group"
  description = "name of the Azure resource group"
}


variable "location" {
  type        = string
  default     = "centralindia"
  description = "Azure resource location"
}

variable "address_space" {
  type        = list(string)
  default     = ["192.168.0.0/16"]
  description = "Address spece for azure vnet"
}

variable "address_prefix" {
  type        = string
  default     = "192.168.1.0/24"
  description = "Address prefix for azure vnet"
}

variable "prefix" {
  type    = string
  default = "abcde"
}
