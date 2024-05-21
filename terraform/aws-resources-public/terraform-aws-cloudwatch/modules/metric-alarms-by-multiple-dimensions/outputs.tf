output "cloudwatch_metric_alarm_arns" {
  description = "List of ARNs of the Cloudwatch metric alarm"
  value       = module.terraform-aws-cloudwatch.cloudwatch_metric_alarm_arns
}

output "cloudwatch_metric_alarm_ids" {
  description = "List of IDs of the Cloudwatch metric alarm"
  value       = module.terraform-aws-cloudwatch.cloudwatch_metric_alarm_ids
}

