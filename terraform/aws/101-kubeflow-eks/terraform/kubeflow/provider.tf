terraform {
  backend "local" {}
  required_providers {
    rafay = {
      version = "= 1.1.15"
      source = "registry.terraform.io/RafaySystems/rafay"
    }
  }
  required_version = ">= 1.4.4"
}
