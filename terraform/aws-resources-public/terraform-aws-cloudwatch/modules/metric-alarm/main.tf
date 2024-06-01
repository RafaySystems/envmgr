module "cloudwatch_metric-alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "5.3.1"

  create_metric_alarm = var.create_metric_alarm
  alarm_name = var.alarm_name
  alarm_description = var.alarm_description
  comparison_operator = var.comparison_operator
  evaluation_periods = var.evaluation_periods
  threshold = var.threshold
  threshold_metric_id = var.threshold_metric_id
  unit = var.unit
  metric_name = var.metric_name
  namespace = var.namespace
  period = var.period
  statistic = var.statistic
  actions_enabled = var.actions_enabled
  datapoints_to_alarm = var.datapoints_to_alarm
  dimensions = var.dimensions
  alarm_actions = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions
  ok_actions = var.ok_actions
  extended_statistic = var.extended_statistic
  treat_missing_data = var.treat_missing_data
  evaluate_low_sample_count_percentiles = var.evaluate_low_sample_count_percentiles
  metric_query = var.metric_query
  tags = var.tags
}
