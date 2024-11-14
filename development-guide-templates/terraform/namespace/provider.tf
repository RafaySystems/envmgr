terraform {
  backend "local" {}
  required_providers {
    rafay = {
      version = ">=1.1.37"
      source  = "RafaySystems/rafay"
    }
  }
  required_version = ">= 1.4.4"
}
