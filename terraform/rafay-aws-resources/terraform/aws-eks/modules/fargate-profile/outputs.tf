output "iam_role_name" {
  description = "The name of the IAM role"
  value       = module.terraform-aws-eks.iam_role_name
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = module.terraform-aws-eks.iam_role_arn
}

output "iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = module.terraform-aws-eks.iam_role_unique_id
}

output "fargate_profile_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Fargate Profile"
  value       = module.terraform-aws-eks.fargate_profile_arn
}

output "fargate_profile_id" {
  description = "EKS Cluster name and EKS Fargate Profile name separated by a colon (`:`)"
  value       = module.terraform-aws-eks.fargate_profile_id
}

output "fargate_profile_status" {
  description = "Status of the EKS Fargate Profile"
  value       = module.terraform-aws-eks.fargate_profile_status
}

output "fargate_profile_pod_execution_role_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Fargate Profile Pod execution role ARN"
  value       = module.terraform-aws-eks.fargate_profile_pod_execution_role_arn
}

