terraform {
  required_version = ">= 1.5.0"

  required_providers {
    rafay = {
      source  = "RafaySystems/rafay"
      version = ">=1.1.23"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.4.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.20.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.9.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = local.host
  client_certificate     = base64decode(local.client_certificate_data)
  client_key             = base64decode(local.client_key_data)
  cluster_ca_certificate = base64decode(local.certificate_authority_data)
}

provider "helm" {
  kubernetes = {
    host                   = local.host
    client_certificate     = base64decode(local.client_certificate_data)
    client_key             = base64decode(local.client_key_data)
    cluster_ca_certificate = base64decode(local.certificate_authority_data)
  }
}