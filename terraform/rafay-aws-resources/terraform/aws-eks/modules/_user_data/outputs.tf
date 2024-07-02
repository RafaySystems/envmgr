output "user_data" {
  description = "Base64 encoded user data rendered for the provided inputs"
  value       = module.terraform-aws-eks.user_data
}

output "platform" {
  description = "[DEPRECATED - Will be removed in `v21.0`] Identifies the OS platform as `bottlerocket`, `linux` (AL2), `al2023, or `windows`"
  value       = module.terraform-aws-eks.platform
}

