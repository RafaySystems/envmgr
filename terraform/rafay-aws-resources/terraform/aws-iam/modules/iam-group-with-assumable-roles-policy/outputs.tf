output "group_users" {
  description = "List of IAM users in IAM group"
  value       = module.terraform-aws-iam.group_users
}

output "assumable_roles" {
  description = "List of ARNs of IAM roles which members of IAM group can assume"
  value       = module.terraform-aws-iam.assumable_roles
}

output "policy_arn" {
  description = "Assume role policy ARN of IAM group"
  value       = module.terraform-aws-iam.policy_arn
}

output "group_name" {
  description = "IAM group name"
  value       = module.terraform-aws-iam.group_name
}

output "group_arn" {
  description = "IAM group arn"
  value       = module.terraform-aws-iam.group_arn
}

