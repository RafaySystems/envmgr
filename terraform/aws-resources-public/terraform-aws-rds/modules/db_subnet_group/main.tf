module "terraform-aws-rds" {
  source  = "terraform-aws-rds//modules/db_subnet_group"
  version = "6.5.5"

  create = var.create
  name = var.name
  use_name_prefix = var.use_name_prefix
  description = var.description
  subnet_ids = var.subnet_ids
  tags = var.tags
}
