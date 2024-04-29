module "terraform-aws-vpc" {
  source  = "terraform-aws-vpc//modules/vpc-endpoints"
  version = "5.7.1"

  create = var.create
  vpc_id = var.vpc_id
  endpoints = var.endpoints
  security_group_ids = var.security_group_ids
  subnet_ids = var.subnet_ids
  tags = var.tags
  timeouts = var.timeouts
  create_security_group = var.create_security_group
  security_group_name = var.security_group_name
  security_group_name_prefix = var.security_group_name_prefix
  security_group_description = var.security_group_description
  security_group_rules = var.security_group_rules
  security_group_tags = var.security_group_tags
}
