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

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}
