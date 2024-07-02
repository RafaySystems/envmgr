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

output "autoscaling_group_arn" {
  description = "The ARN for this autoscaling group"
  value       = module.terraform-aws-eks.autoscaling_group_arn
}

output "autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = module.terraform-aws-eks.autoscaling_group_id
}

output "autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = module.terraform-aws-eks.autoscaling_group_name
}

output "autoscaling_group_min_size" {
  description = "The minimum size of the autoscaling group"
  value       = module.terraform-aws-eks.autoscaling_group_min_size
}

output "autoscaling_group_max_size" {
  description = "The maximum size of the autoscaling group"
  value       = module.terraform-aws-eks.autoscaling_group_max_size
}

output "autoscaling_group_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = module.terraform-aws-eks.autoscaling_group_desired_capacity
}

output "autoscaling_group_default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity"
  value       = module.terraform-aws-eks.autoscaling_group_default_cooldown
}

output "autoscaling_group_health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  value       = module.terraform-aws-eks.autoscaling_group_health_check_grace_period
}

output "autoscaling_group_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  value       = module.terraform-aws-eks.autoscaling_group_health_check_type
}

output "autoscaling_group_availability_zones" {
  description = "The availability zones of the autoscaling group"
  value       = module.terraform-aws-eks.autoscaling_group_availability_zones
}

output "autoscaling_group_vpc_zone_identifier" {
  description = "The VPC zone identifier"
  value       = module.terraform-aws-eks.autoscaling_group_vpc_zone_identifier
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

output "iam_instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  value       = module.terraform-aws-eks.iam_instance_profile_arn
}

output "iam_instance_profile_id" {
  description = "Instance profile's ID"
  value       = module.terraform-aws-eks.iam_instance_profile_id
}

output "iam_instance_profile_unique" {
  description = "Stable and unique string identifying the IAM instance profile"
  value       = module.terraform-aws-eks.iam_instance_profile_unique
}

output "access_entry_arn" {
  description = "Amazon Resource Name (ARN) of the Access Entry"
  value       = module.terraform-aws-eks.access_entry_arn
}

output "autoscaling_group_schedule_arns" {
  description = "ARNs of autoscaling group schedules"
  value       = module.terraform-aws-eks.autoscaling_group_schedule_arns
}

output "platform" {
  description = "[DEPRECATED - Will be removed in `v21.0`] Identifies the OS platform as `bottlerocket`, `linux` (AL2), `al2023`, or `windows`"
  value       = module.terraform-aws-eks.platform
}

output "image_id" {
  description = "ID of the image"
  value       = module.terraform-aws-eks.image_id
}

output "user_data" {
  description = "Base64 encoded user data"
  value       = module.terraform-aws-eks.user_data
}

