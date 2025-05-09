terraform {
  required_version = ">=1.5.7"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "2.3.4"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.8.1"
    }
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}
