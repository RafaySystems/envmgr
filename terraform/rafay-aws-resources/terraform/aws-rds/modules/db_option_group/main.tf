module "terraform-aws-rds" {
  source  = "terraform-aws-rds//modules/db_option_group"
  version = "6.5.5"

  create = var.create
  name = var.name
  use_name_prefix = var.use_name_prefix
  option_group_description = var.option_group_description
  engine_name = var.engine_name
  major_engine_version = var.major_engine_version
  options = var.options
  timeouts = var.timeouts
  tags = var.tags
}
