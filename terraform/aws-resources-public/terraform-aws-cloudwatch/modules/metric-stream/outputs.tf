output "cloudwatch_metric_stream" {
  description = "ARN of the metric stream."
  value       = module.terraform-aws-cloudwatch.cloudwatch_metric_stream
}

output "cloudwatch_metric_stream_creation_date" {
  description = "Date and time in RFC3339 format that the metric stream was created."
  value       = module.terraform-aws-cloudwatch.cloudwatch_metric_stream_creation_date
}

output "cloudwatch_metric_stream_last_update_date" {
  description = "Date and time in RFC3339 format that the metric stream was last updated."
  value       = module.terraform-aws-cloudwatch.cloudwatch_metric_stream_last_update_date
}

output "cloudwatch_metric_stream_state" {
  description = "State of the metric stream. Possible values are running and stopped."
  value       = module.terraform-aws-cloudwatch.cloudwatch_metric_stream_state
}

