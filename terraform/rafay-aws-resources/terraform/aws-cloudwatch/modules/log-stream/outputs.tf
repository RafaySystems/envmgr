output "cloudwatch_log_stream_name" {
  description = "Name of Cloudwatch log stream"
  value       = module.cloudwatch_log-stream.cloudwatch_log_stream_name
}

output "cloudwatch_log_stream_arn" {
  description = "ARN of Cloudwatch log stream"
  value       = module.cloudwatch_log-stream.cloudwatch_log_stream_arn
}

