output "cloudwatch_composite_alarm_arn" {
  description = "The ARN of the Cloudwatch composite alarm."
  value       = module.cloudwatch_composite-alarm.cloudwatch_composite_alarm_arn
}

output "cloudwatch_composite_alarm_id" {
  description = "The ID of the Cloudwatch composite alarm."
  value       = module.cloudwatch_composite-alarm.cloudwatch_composite_alarm_id
}

