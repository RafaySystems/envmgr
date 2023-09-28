variable "resource_group_name" {
  type        = string
  default     = "em-rs-group"
  description = "name of the Azure resource group"
}


variable "location" {
  type        = string
  default     = "centralindia"
  description = "Azure resource location"
}

variable "address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Address spece for azure vnet"
}

variable "address_prefix" {
  type        = string
  default     = " 10.0.1.0/24"
  description = "Address prefix for azure vnet"
}

variable "size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "prefix" {
  type    = string
  default = "abcde"
}
