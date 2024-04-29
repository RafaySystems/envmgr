module "terraform-aws-iam" {
  source  = "terraform-aws-iam//modules/iam-read-only-policy"
  version = "5.39.0"

  create_policy = var.create_policy
  name = var.name
  name_prefix = var.name_prefix
  path = var.path
  description = var.description
  allowed_services = var.allowed_services
  additional_policy_json = var.additional_policy_json
  tags = var.tags
  allow_cloudwatch_logs_query = var.allow_cloudwatch_logs_query
  allow_predefined_sts_actions = var.allow_predefined_sts_actions
  allow_web_console_services = var.allow_web_console_services
  web_console_services = var.web_console_services
}
