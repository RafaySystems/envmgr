output "cloudwatch_log_metric_filter_id" {
  description = "The name of the metric filter"
  value       = module.terraform-aws-cloudwatch.cloudwatch_log_metric_filter_id
}

