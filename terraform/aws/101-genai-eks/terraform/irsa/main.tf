data "aws_eks_cluster" "default" {
  name = var.cluster_name
}

data "tls_certificate" "default" {
  url = data.aws_eks_cluster.default.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "default" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.default.certificates[0].sha1_fingerprint]
  url             = data.aws_eks_cluster.default.identity[0].oidc[0].issuer
}

resource "aws_iam_role" "default" {
  name = "bedrock-irsa-role-${var.namespace}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid    = ""
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.default.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
            "${aws_iam_openid_connect_provider.default.url}:sub" = "system:serviceaccount:${var.namespace}:genai"
            "${aws_iam_openid_connect_provider.default.url}:aud" = "sts.amazonaws.com"
          }
      }
    }]
  })
}

resource "aws_iam_role_policy" "default" {
  name   = "bedrock-irsa-policy-${var.namepsace}"
  role   = aws_iam_role.default.id
  policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
       {
           Effect   = "Allow"
           Action   = ["bedrock:*"]
           Resource = "*"
       }
   ]
})
}


resource "kubernetes_service_account" "genai_service_account" {
  metadata {
    name      = "genai"
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.default.arn
    }
  }
}
