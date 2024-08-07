module "terraform-aws-lambda" {
  source  = "terraform-aws-lambda//modules/deploy"
  version = "7.7.0"

  create = var.create
  tags = var.tags
  alias_name = var.alias_name
  function_name = var.function_name
  current_version = var.current_version
  target_version = var.target_version
  before_allow_traffic_hook_arn = var.before_allow_traffic_hook_arn
  after_allow_traffic_hook_arn = var.after_allow_traffic_hook_arn
  interpreter = var.interpreter
  description = var.description
  create_app = var.create_app
  use_existing_app = var.use_existing_app
  app_name = var.app_name
  create_deployment_group = var.create_deployment_group
  use_existing_deployment_group = var.use_existing_deployment_group
  deployment_group_name = var.deployment_group_name
  deployment_config_name = var.deployment_config_name
  auto_rollback_enabled = var.auto_rollback_enabled
  auto_rollback_events = var.auto_rollback_events
  alarm_enabled = var.alarm_enabled
  alarms = var.alarms
  alarm_ignore_poll_alarm_failure = var.alarm_ignore_poll_alarm_failure
  triggers = var.triggers
  aws_cli_command = var.aws_cli_command
  save_deploy_script = var.save_deploy_script
  create_deployment = var.create_deployment
  run_deployment = var.run_deployment
  force_deploy = var.force_deploy
  wait_deployment_completion = var.wait_deployment_completion
  create_codedeploy_role = var.create_codedeploy_role
  codedeploy_role_name = var.codedeploy_role_name
  codedeploy_principals = var.codedeploy_principals
  attach_hooks_policy = var.attach_hooks_policy
  attach_triggers_policy = var.attach_triggers_policy
  get_deployment_sleep_timer = var.get_deployment_sleep_timer
}
