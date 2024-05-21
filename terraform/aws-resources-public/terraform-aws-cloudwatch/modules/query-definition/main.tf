module "terraform-aws-cloudwatch" {
  source  = "terraform-aws-cloudwatch//modules/query-definition"
  version = "5.3.1"

  create = var.create
  name = var.name
  query_string = var.query_string
  log_group_names = var.log_group_names
}
