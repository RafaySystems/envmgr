module "terraform-aws-iam" {
  source  = "terraform-aws-iam//modules/iam-group-with-policies"
  version = "5.39.0"

  create_group = var.create_group
  name = var.name
  path = var.path
  group_users = var.group_users
  custom_group_policy_arns = var.custom_group_policy_arns
  custom_group_policies = var.custom_group_policies
  enable_mfa_enforcement = var.enable_mfa_enforcement
  attach_iam_self_management_policy = var.attach_iam_self_management_policy
  iam_self_management_policy_name_prefix = var.iam_self_management_policy_name_prefix
  aws_account_id = var.aws_account_id
  tags = var.tags
}
