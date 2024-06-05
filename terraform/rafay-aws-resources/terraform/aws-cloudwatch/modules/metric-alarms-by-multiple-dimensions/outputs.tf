output "cloudwatch_metric_alarm_arns" {
  description = "List of ARNs of the Cloudwatch metric alarm"
  value       = module.cloudwatch_metric-alarms-by-multiple-dimensions.cloudwatch_metric_alarm_arns
}

output "cloudwatch_metric_alarm_ids" {
  description = "List of IDs of the Cloudwatch metric alarm"
  value       = module.cloudwatch_metric-alarms-by-multiple-dimensions.cloudwatch_metric_alarm_ids
}

