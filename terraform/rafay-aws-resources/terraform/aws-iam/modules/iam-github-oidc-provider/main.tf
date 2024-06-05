module "terraform-aws-iam" {
  source  = "terraform-aws-iam//modules/iam-github-oidc-provider"
  version = "5.39.0"

  create = var.create
  tags = var.tags
  client_id_list = var.client_id_list
  url = var.url
  additional_thumbprints = var.additional_thumbprints
}
