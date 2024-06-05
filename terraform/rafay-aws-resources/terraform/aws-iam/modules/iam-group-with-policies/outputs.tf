output "aws_account_id" {
  description = "IAM AWS account id"
  value       = module.terraform-aws-iam.aws_account_id
}

output "group_arn" {
  description = "IAM group arn"
  value       = module.terraform-aws-iam.group_arn
}

output "group_users" {
  description = "List of IAM users in IAM group"
  value       = module.terraform-aws-iam.group_users
}

output "group_name" {
  description = "IAM group name"
  value       = module.terraform-aws-iam.group_name
}

