output "id" {
  description = "The policy's ID"
  value       = module.terraform-aws-iam.id
}

output "arn" {
  description = "The ARN assigned by AWS to this policy"
  value       = module.terraform-aws-iam.arn
}

output "description" {
  description = "The description of the policy"
  value       = module.terraform-aws-iam.description
}

output "name" {
  description = "The name of the policy"
  value       = module.terraform-aws-iam.name
}

output "path" {
  description = "The path of the policy in IAM"
  value       = module.terraform-aws-iam.path
}

output "policy" {
  description = "The policy document"
  value       = module.terraform-aws-iam.policy
}

