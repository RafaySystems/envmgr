terraform {
  required_providers {
    rafay = {
      source = "rafaysystems/rafay"
      version = "1.1.42"
    }
  }
}

provider "rafay" {
 provider_config_file = var.rctl_config_path
}
