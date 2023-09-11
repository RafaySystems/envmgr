terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.0"
    }
     rafay = {
      source  = "RafaySystems/rafay"
      version = "1.1.15"
    }
  }
}

provider "azurerm" {
 features {}
}