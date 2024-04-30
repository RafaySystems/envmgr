output "db_option_group_id" {
  description = "The db option group id"
  value       = module.terraform-aws-rds.db_option_group_id
}

output "db_option_group_arn" {
  description = "The ARN of the db option group"
  value       = module.terraform-aws-rds.db_option_group_arn
}

