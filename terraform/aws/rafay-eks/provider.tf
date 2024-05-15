terraform {
  required_providers {
    rafay = {
      version = ">= 0.1"
      source  = "registry.terraform.io/RafaySystems/rafay"
    }
    aws = {
      source = "hashicorp/aws"
      region = var.region
    }
  }
}
