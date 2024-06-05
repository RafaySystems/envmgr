output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = module.terraform-aws-iam.iam_role_arn
}

output "iam_role_name" {
  description = "Name of IAM role"
  value       = module.terraform-aws-iam.iam_role_name
}

output "iam_role_path" {
  description = "Path of IAM role"
  value       = module.terraform-aws-iam.iam_role_path
}

output "iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = module.terraform-aws-iam.iam_role_unique_id
}

output "role_requires_mfa" {
  description = "Whether IAM role requires MFA"
  value       = module.terraform-aws-iam.role_requires_mfa
}

output "iam_instance_profile_arn" {
  description = "ARN of IAM instance profile"
  value       = module.terraform-aws-iam.iam_instance_profile_arn
}

output "iam_instance_profile_name" {
  description = "Name of IAM instance profile"
  value       = module.terraform-aws-iam.iam_instance_profile_name
}

output "iam_instance_profile_id" {
  description = "IAM Instance profile's ID."
  value       = module.terraform-aws-iam.iam_instance_profile_id
}

output "iam_instance_profile_path" {
  description = "Path of IAM instance profile"
  value       = module.terraform-aws-iam.iam_instance_profile_path
}

output "role_sts_externalid" {
  description = "STS ExternalId condition value to use with a role"
  value       = module.terraform-aws-iam.role_sts_externalid
}

