module "terraform-aws-iam" {
  source  = "terraform-aws-iam//modules/iam-assumable-role"
  version = "5.39.0"

  trusted_role_actions = var.trusted_role_actions
  trusted_role_arns = var.trusted_role_arns
  trusted_role_services = var.trusted_role_services
  mfa_age = var.mfa_age
  max_session_duration = var.max_session_duration
  create_role = var.create_role
  create_instance_profile = var.create_instance_profile
  role_name = var.role_name
  role_name_prefix = var.role_name_prefix
  role_path = var.role_path
  role_requires_mfa = var.role_requires_mfa
  role_permissions_boundary_arn = var.role_permissions_boundary_arn
  tags = var.tags
  custom_role_policy_arns = var.custom_role_policy_arns
  custom_role_trust_policy = var.custom_role_trust_policy
  create_custom_role_trust_policy = var.create_custom_role_trust_policy
  number_of_custom_role_policy_arns = var.number_of_custom_role_policy_arns
  admin_role_policy_arn = var.admin_role_policy_arn
  poweruser_role_policy_arn = var.poweruser_role_policy_arn
  readonly_role_policy_arn = var.readonly_role_policy_arn
  attach_admin_policy = var.attach_admin_policy
  attach_poweruser_policy = var.attach_poweruser_policy
  attach_readonly_policy = var.attach_readonly_policy
  force_detach_policies = var.force_detach_policies
  role_description = var.role_description
  role_sts_externalid = var.role_sts_externalid
  allow_self_assume_role = var.allow_self_assume_role
  role_requires_session_name = var.role_requires_session_name
  role_session_name = var.role_session_name
}
