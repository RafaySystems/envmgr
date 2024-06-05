module "terraform-aws-rds" {
  source  = "terraform-aws-rds//modules/db_instance_role_association"
  version = "6.5.5"

  create = var.create
  feature_name = var.feature_name
  role_arn = var.role_arn
  db_instance_identifier = var.db_instance_identifier
}
