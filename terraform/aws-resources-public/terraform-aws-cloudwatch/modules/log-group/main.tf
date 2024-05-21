module "terraform-aws-cloudwatch" {
  source  = "terraform-aws-cloudwatch//modules/log-group"
  version = "5.3.1"

  create = var.create
  name = var.name
  name_prefix = var.name_prefix
  retention_in_days = var.retention_in_days
  kms_key_id = var.kms_key_id
  log_group_class = var.log_group_class
  skip_destroy = var.skip_destroy
  tags = var.tags
}
