terraform {
  required_providers {
    rafay = {
      version = ">= 1.0"
      source  = "registry.terraform.io/RafaySystems/rafay"
    }
  }
}

provider "rafay" {}