# Please visit the following link for provider details
# https://registry.terraform.io/providers/RafaySystems/rafay/latest/docs

terraform {
  backend "local" {}
  required_providers {
    rafay = {
      version = "= 1.1.24"
      source = "registry.terraform.io/RafaySystems/rafay"
    }
  }
  required_version = ">= 1.4.4"
}
