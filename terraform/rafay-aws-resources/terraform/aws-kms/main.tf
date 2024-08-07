module "terraform-aws-kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.0"

  create = var.create
  tags = var.tags
  create_external = var.create_external
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  customer_master_key_spec = var.customer_master_key_spec
  custom_key_store_id = var.custom_key_store_id
  deletion_window_in_days = var.deletion_window_in_days
  description = var.description
  enable_key_rotation = var.enable_key_rotation
  is_enabled = var.is_enabled
  key_material_base64 = var.key_material_base64
  key_usage = var.key_usage
  multi_region = var.multi_region
  policy = var.policy
  valid_to = var.valid_to
  enable_default_policy = var.enable_default_policy
  key_owners = var.key_owners
  key_administrators = var.key_administrators
  key_users = var.key_users
  key_service_users = var.key_service_users
  key_service_roles_for_autoscaling = var.key_service_roles_for_autoscaling
  key_symmetric_encryption_users = var.key_symmetric_encryption_users
  key_hmac_users = var.key_hmac_users
  key_asymmetric_public_encryption_users = var.key_asymmetric_public_encryption_users
  key_asymmetric_sign_verify_users = var.key_asymmetric_sign_verify_users
  key_statements = var.key_statements
  source_policy_documents = var.source_policy_documents
  override_policy_documents = var.override_policy_documents
  enable_route53_dnssec = var.enable_route53_dnssec
  route53_dnssec_sources = var.route53_dnssec_sources
  rotation_period_in_days = var.rotation_period_in_days
  create_replica = var.create_replica
  primary_key_arn = var.primary_key_arn
  create_replica_external = var.create_replica_external
  primary_external_key_arn = var.primary_external_key_arn
  aliases = var.aliases
  computed_aliases = var.computed_aliases
  aliases_use_name_prefix = var.aliases_use_name_prefix
  grants = var.grants
}
