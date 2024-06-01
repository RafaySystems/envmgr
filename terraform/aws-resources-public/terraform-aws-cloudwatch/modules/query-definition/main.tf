module "cloudwatch_query-definition" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/query-definition"
  version = "5.3.1"

  create = var.create
  name = var.name
  query_string = var.query_string
  log_group_names = var.log_group_names
}
