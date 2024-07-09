output "iam_role_name" {
  description = "The name of the controller IAM role"
  value       = module.terraform-aws-eks.iam_role_name
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the controller IAM role"
  value       = module.terraform-aws-eks.iam_role_arn
}

output "iam_role_unique_id" {
  description = "Stable and unique string identifying the controller IAM role"
  value       = module.terraform-aws-eks.iam_role_unique_id
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = module.terraform-aws-eks.queue_arn
}

output "queue_name" {
  description = "The name of the created Amazon SQS queue"
  value       = module.terraform-aws-eks.queue_name
}

output "queue_url" {
  description = "The URL for the created Amazon SQS queue"
  value       = module.terraform-aws-eks.queue_url
}

output "event_rules" {
  description = "Map of the event rules created and their attributes"
  value       = module.terraform-aws-eks.event_rules
}

output "node_iam_role_name" {
  description = "The name of the node IAM role"
  value       = module.terraform-aws-eks.node_iam_role_name
}

output "node_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the node IAM role"
  value       = module.terraform-aws-eks.node_iam_role_arn
}

output "node_iam_role_unique_id" {
  description = "Stable and unique string identifying the node IAM role"
  value       = module.terraform-aws-eks.node_iam_role_unique_id
}

output "node_access_entry_arn" {
  description = "Amazon Resource Name (ARN) of the node Access Entry"
  value       = module.terraform-aws-eks.node_access_entry_arn
}

output "instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  value       = module.terraform-aws-eks.instance_profile_arn
}

output "instance_profile_id" {
  description = "Instance profile's ID"
  value       = module.terraform-aws-eks.instance_profile_id
}

output "instance_profile_name" {
  description = "Name of the instance profile"
  value       = module.terraform-aws-eks.instance_profile_name
}

output "instance_profile_unique" {
  description = "Stable and unique string identifying the IAM instance profile"
  value       = module.terraform-aws-eks.instance_profile_unique
}

output "namespace" {
  description = "Namespace associated with the Karpenter Pod Identity"
  value       = module.terraform-aws-eks.namespace
}

output "service_account" {
  description = "Service Account associated with the Karpenter Pod Identity"
  value       = module.terraform-aws-eks.service_account
}

