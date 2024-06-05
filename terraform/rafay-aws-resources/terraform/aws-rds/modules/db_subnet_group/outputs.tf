output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.terraform-aws-rds.db_subnet_group_id
}

output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.terraform-aws-rds.db_subnet_group_arn
}

