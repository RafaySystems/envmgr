output "db_instance_role_association_id" {
  description = "DB Instance Identifier and IAM Role ARN separated by a comma"
  value       = module.terraform-aws-rds.db_instance_role_association_id
}

