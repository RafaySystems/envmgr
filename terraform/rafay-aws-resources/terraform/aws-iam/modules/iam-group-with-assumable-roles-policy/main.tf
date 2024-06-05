module "terraform-aws-iam" {
  source  = "terraform-aws-iam//modules/iam-group-with-assumable-roles-policy"
  version = "5.39.0"

  name = var.name
  path = var.path
  assumable_roles = var.assumable_roles
  assumable_roles_policy_name_suffix = var.assumable_roles_policy_name_suffix
  group_users = var.group_users
  tags = var.tags
}
