output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.terraform-aws-rds.db_parameter_group_id
}

output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.terraform-aws-rds.db_parameter_group_arn
}

