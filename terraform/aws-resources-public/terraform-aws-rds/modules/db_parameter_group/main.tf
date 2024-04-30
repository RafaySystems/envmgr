module "terraform-aws-rds" {
  source  = "terraform-aws-rds//modules/db_parameter_group"
  version = "6.5.5"

  create = var.create
  name = var.name
  use_name_prefix = var.use_name_prefix
  description = var.description
  family = var.family
  parameters = var.parameters
  tags = var.tags
}
