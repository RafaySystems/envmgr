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

resource "helm_release" "qdarnt" {
  namespace = var.namespace
  wait      = true
  timeout   = 600

  name = "jupyter"
  chart = "./jupyterhub-3.2.1.tgz"

  set {
    name  = "singleuser.serviceAccountName"
    value = var.service-account-name
    type  = "string"
  }

  set {
    name  = "singleuser.extraEnv.QDRANT_URL"
    value = "http://qdrant:6333"
    type  = "string"
  }

  set {
    name  = "singleuser.extraEnv.OPEN_AI_SECRET_PREFIX"
    value = "OPEN_AI_KEY"
    type  = "string"
  }

  set {
    name = "hub.config.Authenticator.admin_users[0]"
    value = "admin"
  }

  set {
    name = "hub.config.DummyAuthenticator.password"
    value = var.jupyter_admin_password
  }

}

data "kubernetes_service" "proxy_public_svc" {
  metadata {
    name = "proxy-public"
    namespace = var.namespace
  }
  depends_on = ["helm_release.qdarnt"]
}




