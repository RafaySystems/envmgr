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


variable "subnet_id" {
  type        = string
  description = "Azure subnet ID"
}

variable "size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "prefix" {
  type    = string
  default = "abcde"
}
