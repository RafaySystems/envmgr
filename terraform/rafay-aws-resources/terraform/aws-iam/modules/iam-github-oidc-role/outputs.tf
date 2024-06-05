output "arn" {
  description = "ARN of IAM role"
  value       = module.terraform-aws-iam.arn
}

output "name" {
  description = "Name of IAM role"
  value       = module.terraform-aws-iam.name
}

output "path" {
  description = "Path of IAM role"
  value       = module.terraform-aws-iam.path
}

output "unique_id" {
  description = "Unique ID of IAM role"
  value       = module.terraform-aws-iam.unique_id
}

