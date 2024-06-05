output "admin_iam_role_arn" {
  description = "ARN of admin IAM role"
  value       = module.terraform-aws-iam.admin_iam_role_arn
}

output "admin_iam_role_name" {
  description = "Name of admin IAM role"
  value       = module.terraform-aws-iam.admin_iam_role_name
}

output "admin_iam_role_path" {
  description = "Path of admin IAM role"
  value       = module.terraform-aws-iam.admin_iam_role_path
}

output "admin_iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = module.terraform-aws-iam.admin_iam_role_unique_id
}

output "admin_iam_role_requires_mfa" {
  description = "Whether admin IAM role requires MFA"
  value       = module.terraform-aws-iam.admin_iam_role_requires_mfa
}

output "poweruser_iam_role_arn" {
  description = "ARN of poweruser IAM role"
  value       = module.terraform-aws-iam.poweruser_iam_role_arn
}

output "poweruser_iam_role_name" {
  description = "Name of poweruser IAM role"
  value       = module.terraform-aws-iam.poweruser_iam_role_name
}

output "poweruser_iam_role_path" {
  description = "Path of poweruser IAM role"
  value       = module.terraform-aws-iam.poweruser_iam_role_path
}

output "poweruser_iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = module.terraform-aws-iam.poweruser_iam_role_unique_id
}

output "poweruser_iam_role_requires_mfa" {
  description = "Whether poweruser IAM role requires MFA"
  value       = module.terraform-aws-iam.poweruser_iam_role_requires_mfa
}

output "readonly_iam_role_arn" {
  description = "ARN of readonly IAM role"
  value       = module.terraform-aws-iam.readonly_iam_role_arn
}

output "readonly_iam_role_name" {
  description = "Name of readonly IAM role"
  value       = module.terraform-aws-iam.readonly_iam_role_name
}

output "readonly_iam_role_path" {
  description = "Path of readonly IAM role"
  value       = module.terraform-aws-iam.readonly_iam_role_path
}

output "readonly_iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = module.terraform-aws-iam.readonly_iam_role_unique_id
}

output "readonly_iam_role_requires_mfa" {
  description = "Whether readonly IAM role requires MFA"
  value       = module.terraform-aws-iam.readonly_iam_role_requires_mfa
}

