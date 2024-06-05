module "terraform-aws-iam" {
  source  = "terraform-aws-iam//modules/iam-policy"
  version = "5.39.0"

  create_policy = var.create_policy
  name = var.name
  name_prefix = var.name_prefix
  path = var.path
  description = var.description
  policy = var.policy
  tags = var.tags
}
