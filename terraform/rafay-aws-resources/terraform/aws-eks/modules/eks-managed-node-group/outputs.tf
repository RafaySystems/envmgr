output "launch_template_id" {
  description = "The ID of the launch template"
  value       = module.terraform-aws-eks.launch_template_id
}

output "launch_template_arn" {
  description = "The ARN of the launch template"
  value       = module.terraform-aws-eks.launch_template_arn
}

output "launch_template_latest_version" {
  description = "The latest version of the launch template"
  value       = module.terraform-aws-eks.launch_template_latest_version
}

output "launch_template_name" {
  description = "The name of the launch template"
  value       = module.terraform-aws-eks.launch_template_name
}

output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = module.terraform-aws-eks.node_group_arn
}

output "node_group_id" {
  description = "EKS Cluster name and EKS Node Group name separated by a colon (`:`)"
  value       = module.terraform-aws-eks.node_group_id
}

output "node_group_resources" {
  description = "List of objects containing information about underlying resources"
  value       = module.terraform-aws-eks.node_group_resources
}

output "node_group_autoscaling_group_names" {
  description = "List of the autoscaling group names"
  value       = module.terraform-aws-eks.node_group_autoscaling_group_names
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = module.terraform-aws-eks.node_group_status
}

output "node_group_labels" {
  description = "Map of labels applied to the node group"
  value       = module.terraform-aws-eks.node_group_labels
}

output "node_group_taints" {
  description = "List of objects containing information about taints applied to the node group"
  value       = module.terraform-aws-eks.node_group_taints
}

output "autoscaling_group_schedule_arns" {
  description = "ARNs of autoscaling group schedules"
  value       = module.terraform-aws-eks.autoscaling_group_schedule_arns
}

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

output "platform" {
  description = "[DEPRECATED - Will be removed in `v21.0`] Identifies the OS platform as `bottlerocket`, `linux` (AL2), `al2023`, or `windows`"
  value       = module.terraform-aws-eks.platform
}

