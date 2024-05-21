module "terraform-aws-cloudwatch" {
  source  = "terraform-aws-cloudwatch//modules/composite-alarm"
  version = "5.3.1"

  create = var.create
  alarm_name = var.alarm_name
  alarm_description = var.alarm_description
  actions_enabled = var.actions_enabled
  actions_suppressor = var.actions_suppressor
  alarm_actions = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions
  ok_actions = var.ok_actions
  alarm_rule = var.alarm_rule
  tags = var.tags
}
