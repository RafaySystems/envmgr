module "terraform-aws-cloudwatch" {
  source  = "terraform-aws-cloudwatch//modules/log-stream"
  version = "5.3.1"

  create = var.create
  name = var.name
  log_group_name = var.log_group_name
}
