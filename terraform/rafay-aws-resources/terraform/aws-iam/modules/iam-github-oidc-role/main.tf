module "terraform-aws-iam" {
  source  = "terraform-aws-iam//modules/iam-github-oidc-role"
  version = "5.39.0"

  create = var.create
  tags = var.tags
  name = var.name
  path = var.path
  permissions_boundary_arn = var.permissions_boundary_arn
  description = var.description
  name_prefix = var.name_prefix
  policies = var.policies
  force_detach_policies = var.force_detach_policies
  max_session_duration = var.max_session_duration
  audience = var.audience
  subjects = var.subjects
  provider_url = var.provider_url
}
