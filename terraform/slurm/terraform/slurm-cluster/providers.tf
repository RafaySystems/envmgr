terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.17.0"
    }
    rafay = {
      source  = "RafaySystems/rafay"
      version = "1.1.30"
    }
  }
}

#provider "helm" {
#  kubernetes {
#    config_path = "kubeconfig.json"
#  }
#}

provider "http" {}

provider "local" {}

# Download kubeconfig.json from URL
data "http" "kubeconfig" {
  url = var.kubeconfig_url
}

# Save it to a local file
resource "local_file" "kubeconfig_file" {
  filename = "${path.module}/kubeconfig.json"
  content  = data.http.kubeconfig.body
}

# Wait for the file to exist (optional safety using null_resource)
resource "null_resource" "wait_for_kubeconfig" {
  depends_on = [local_file.kubeconfig_file]
}

# Use the kubeconfig in the Helm provider
provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig_file.filename
  }
  depends_on = [null_resource.wait_for_kubeconfig]
}


provider "rafay" {
  provider_config_file = var.rctl_config_path
}
