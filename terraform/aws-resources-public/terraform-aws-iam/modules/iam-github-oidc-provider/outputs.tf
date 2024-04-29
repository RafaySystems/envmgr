output "arn" {
  description = "The ARN assigned by AWS for this provider"
  value       = module.terraform-aws-iam.arn
}

output "url" {
  description = "The URL of the identity provider. Corresponds to the iss claim"
  value       = module.terraform-aws-iam.url
}

