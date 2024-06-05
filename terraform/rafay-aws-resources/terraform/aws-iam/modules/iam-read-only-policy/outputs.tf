output "policy_json" {
  description = "Policy document as json. Useful if you need document but do not want to create IAM policy itself. For example for SSO Permission Set inline policies"
  value       = module.terraform-aws-iam.policy_json
}

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

