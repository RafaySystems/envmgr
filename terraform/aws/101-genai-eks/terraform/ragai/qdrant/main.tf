provider "aws" {
    region = var.region
}
data "aws_eks_cluster" "cluster" {
    name = var.cluster_name
}
data "aws_eks_cluster_auth" "ephemeral" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.ephemeral.token
  }
}


resource "helm_release" "qdarnt" {
  namespace = var.namespace
  wait      = true
  timeout   = 600

  name = "qdrant"
  chart = "./qdrant-0.6.1.tgz"
}

