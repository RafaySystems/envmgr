module "terraform-aws-rds" {
  source  = "terraform-aws-rds//modules/db_instance_automated_backups_replication"
  version = "6.5.5"

  create = var.create
  kms_key_arn = var.kms_key_arn
  pre_signed_url = var.pre_signed_url
  retention_period = var.retention_period
  source_db_instance_arn = var.source_db_instance_arn
}
