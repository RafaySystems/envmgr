output "endpoints" {
  description = "Array containing the full resource object and attributes for all endpoints created"
  value       = module.terraform-aws-vpc.endpoints
}

output "security_group_arn" {
  description = "Amazon Resource Name (ARN) of the security group"
  value       = module.terraform-aws-vpc.security_group_arn
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.terraform-aws-vpc.security_group_id
}

