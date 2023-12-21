provider "aws" {
    region = var.region
}
data "aws_eks_cluster" "cluster" {
    name = var.cluster_name
}
data "aws_eks_cluster_auth" "ephemeral" {
  name = var.cluster_name
}
provider kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.ephemeral.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.ephemeral.token
  }
}

resource "helm_release" "rag_example_app" {
  namespace = var.namespace
  wait      = true
  timeout   = 600

  name = var.namespace
  chart = "../helm/rag-bedrock-openai-qdrant/"

  set {
    name  = "backend.image.repository"
    value = var.backend-image
    type  = "string"
  }

  set {
    name  = "backend.image.tag"
    value = var.backend-image-tag
    type  = "string"
  }

  set {
    name  = "frontend.image.repository"
    value = var.frontend-image
    type  = "string"
  }

  set {
    name  = "frontend.image.tag"
    value = var.frontend-image-tag
    type  = "string"
  }

  set {
    name  = "backend.serviceAccount.name"
    value = var.service-account-name
    type  = "string"
  }

}

data "kubernetes_service" "frontend_app_svc" {
  metadata {
    name = "${var.namespace}-rag-bedrock-openai-qdrant-frontend"
    namespace = var.namespace
  }
  depends_on = [helm_release.rag_example_app]
}




