terraform {
  backend "local" {}
  required_providers {
    rafay = {
      version = "= 1.1.17"
      source = "registry.terraform.io/RafaySystems/rafay"
    }
  }
  required_version = "> 1.4.0"
}


provider "rafay" {
  provider_config_file = var.rafay_config_file
}

variable "rafay_config_file" {
  description = "rafay provider config file for authentication"
  default     = "/opt/rafay/rctl.conf"
}
