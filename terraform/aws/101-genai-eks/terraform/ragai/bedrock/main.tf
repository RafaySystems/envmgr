provider "aws" {
    region = var.region
}

data "aws_caller_identity" "this" {}

data "aws_eks_cluster" "this" {
    name = var.cluster_name
}

locals {
   oidc_provider = replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")

}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service-account-name}"]
    }

    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:oidc-provider/${local.oidc_provider}"]
      type        = "Federated"
    }
  }

  
}



resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name               = "${var.region}-${var.cluster_name}-${var.namespace}-${var.service-account-name}"
}

resource "aws_iam_policy" "bedrock" {
    name = "${var.region}-${var.cluster_name}-${var.namespace}-${var.service-account-name}-bedrock-policy"
    policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "bedrock:InvokeModel"
        ],
        "Resource" : [
          "arn:aws:bedrock:*::foundation-model/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "bedrock" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.bedrock.arn
}

data "aws_eks_cluster_auth" "ephemeral" {
  name = var.cluster_name
}

provider kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.ephemeral.token
}

#resource "kubernetes_namespace" "aidemo" {
#  metadata {
#    name = var.namespace
#  }
#}

resource "kubernetes_service_account" "bedrock" {
  metadata {
    name = var.service-account-name
    namespace = var.namespace
    annotations = {
        "eks.amazonaws.com/role-arn" : aws_iam_role.this.arn
    }
  }
 # depends_on = ["kubernetes_namespace.aidemo"]
}







