module "terraform-aws-iam" {
  source  = "terraform-aws-iam//modules/iam-eks-role"
  version = "5.39.0"

  create_role = var.create_role
  role_name = var.role_name
  role_path = var.role_path
  role_permissions_boundary_arn = var.role_permissions_boundary_arn
  role_description = var.role_description
  role_name_prefix = var.role_name_prefix
  role_policy_arns = var.role_policy_arns
  cluster_service_accounts = var.cluster_service_accounts
  tags = var.tags
  force_detach_policies = var.force_detach_policies
  max_session_duration = var.max_session_duration
  allow_self_assume_role = var.allow_self_assume_role
  assume_role_condition_test = var.assume_role_condition_test
}
