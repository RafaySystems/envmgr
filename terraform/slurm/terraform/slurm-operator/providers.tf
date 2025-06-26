terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.17.0"  # or the specific version you need
    }
  }
}

#provider "helm" {
#  kubernetes {
#    config_path = "kubeconfig.json"
#  }
#}



provider "helm" {
  kubernetes {
    host                   = var.hserver
    client_certificate     = base64decode(var.clientcertificatedata)
    client_key             = base64decode(var.clientkeydata)
    cluster_ca_certificate = base64decode(var.certificateauthoritydata)
  }
}
