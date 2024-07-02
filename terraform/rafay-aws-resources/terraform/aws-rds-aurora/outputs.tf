output "db_subnet_group_name" {
  description = "The db subnet group name"
  value       = module.terraform-aws-rds-aurora.db_subnet_group_name
}

output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = module.terraform-aws-rds-aurora.cluster_arn
}

output "cluster_id" {
  description = "The RDS Cluster Identifier"
  value       = module.terraform-aws-rds-aurora.cluster_id
}

output "cluster_resource_id" {
  description = "The RDS Cluster Resource ID"
  value       = module.terraform-aws-rds-aurora.cluster_resource_id
}

output "cluster_members" {
  description = "List of RDS Instances that are a part of this cluster"
  value       = module.terraform-aws-rds-aurora.cluster_members
}

output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = module.terraform-aws-rds-aurora.cluster_endpoint
}

output "cluster_reader_endpoint" {
  description = "A read-only endpoint for the cluster, automatically load-balanced across replicas"
  value       = module.terraform-aws-rds-aurora.cluster_reader_endpoint
}

output "cluster_engine_version_actual" {
  description = "The running version of the cluster database"
  value       = module.terraform-aws-rds-aurora.cluster_engine_version_actual
}

output "cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = module.terraform-aws-rds-aurora.cluster_database_name
}

output "cluster_port" {
  description = "The database port"
  value       = module.terraform-aws-rds-aurora.cluster_port
}

output "cluster_master_password" {
  description = "The database master password"
  value       = module.terraform-aws-rds-aurora.cluster_master_password
}

output "cluster_master_username" {
  description = "The database master username"
  value       = module.terraform-aws-rds-aurora.cluster_master_username
}

output "cluster_master_user_secret" {
  description = "The generated database master user secret when `manage_master_user_password` is set to `true`"
  value       = module.terraform-aws-rds-aurora.cluster_master_user_secret
}

output "cluster_hosted_zone_id" {
  description = "The Route53 Hosted Zone ID of the endpoint"
  value       = module.terraform-aws-rds-aurora.cluster_hosted_zone_id
}

output "cluster_instances" {
  description = "A map of cluster instances and their attributes"
  value       = module.terraform-aws-rds-aurora.cluster_instances
}

output "additional_cluster_endpoints" {
  description = "A map of additional cluster endpoints and their attributes"
  value       = module.terraform-aws-rds-aurora.additional_cluster_endpoints
}

output "cluster_role_associations" {
  description = "A map of IAM roles associated with the cluster and their attributes"
  value       = module.terraform-aws-rds-aurora.cluster_role_associations
}

output "enhanced_monitoring_iam_role_name" {
  description = "The name of the enhanced monitoring role"
  value       = module.terraform-aws-rds-aurora.enhanced_monitoring_iam_role_name
}

output "enhanced_monitoring_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the enhanced monitoring role"
  value       = module.terraform-aws-rds-aurora.enhanced_monitoring_iam_role_arn
}

output "enhanced_monitoring_iam_role_unique_id" {
  description = "Stable and unique string identifying the enhanced monitoring role"
  value       = module.terraform-aws-rds-aurora.enhanced_monitoring_iam_role_unique_id
}

output "security_group_id" {
  description = "The security group ID of the cluster"
  value       = module.terraform-aws-rds-aurora.security_group_id
}

output "db_cluster_parameter_group_arn" {
  description = "The ARN of the DB cluster parameter group created"
  value       = module.terraform-aws-rds-aurora.db_cluster_parameter_group_arn
}

output "db_cluster_parameter_group_id" {
  description = "The ID of the DB cluster parameter group created"
  value       = module.terraform-aws-rds-aurora.db_cluster_parameter_group_id
}

output "db_parameter_group_arn" {
  description = "The ARN of the DB parameter group created"
  value       = module.terraform-aws-rds-aurora.db_parameter_group_arn
}

output "db_parameter_group_id" {
  description = "The ID of the DB parameter group created"
  value       = module.terraform-aws-rds-aurora.db_parameter_group_id
}

output "db_cluster_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.terraform-aws-rds-aurora.db_cluster_cloudwatch_log_groups
}

output "db_cluster_activity_stream_kinesis_stream_name" {
  description = "The name of the Amazon Kinesis data stream to be used for the database activity stream"
  value       = module.terraform-aws-rds-aurora.db_cluster_activity_stream_kinesis_stream_name
}

output "db_cluster_secretsmanager_secret_rotation_enabled" {
  description = "Specifies whether automatic rotation is enabled for the secret"
  value       = module.terraform-aws-rds-aurora.db_cluster_secretsmanager_secret_rotation_enabled
}

