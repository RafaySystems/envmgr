module "terraform-aws-rds-aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.4.0"

  create = var.create
  name = var.name
  tags = var.tags
  create_db_subnet_group = var.create_db_subnet_group
  db_subnet_group_name = var.db_subnet_group_name
  subnets = var.subnets
  is_primary_cluster = var.is_primary_cluster
  cluster_use_name_prefix = var.cluster_use_name_prefix
  allocated_storage = var.allocated_storage
  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately = var.apply_immediately
  availability_zones = var.availability_zones
  backup_retention_period = var.backup_retention_period
  backtrack_window = var.backtrack_window
  cluster_members = var.cluster_members
  copy_tags_to_snapshot = var.copy_tags_to_snapshot
  database_name = var.database_name
  db_cluster_instance_class = var.db_cluster_instance_class
  db_cluster_db_instance_parameter_group_name = var.db_cluster_db_instance_parameter_group_name
  delete_automated_backups = var.delete_automated_backups
  deletion_protection = var.deletion_protection
  enable_global_write_forwarding = var.enable_global_write_forwarding
  enable_local_write_forwarding = var.enable_local_write_forwarding
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  enable_http_endpoint = var.enable_http_endpoint
  engine = var.engine
  engine_mode = var.engine_mode
  engine_version = var.engine_version
  final_snapshot_identifier = var.final_snapshot_identifier
  global_cluster_identifier = var.global_cluster_identifier
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  domain = var.domain
  domain_iam_role_name = var.domain_iam_role_name
  iops = var.iops
  kms_key_id = var.kms_key_id
  manage_master_user_password = var.manage_master_user_password
  master_user_secret_kms_key_id = var.master_user_secret_kms_key_id
  master_password = var.master_password
  master_username = var.master_username
  network_type = var.network_type
  port = var.port
  preferred_backup_window = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  replication_source_identifier = var.replication_source_identifier
  restore_to_point_in_time = var.restore_to_point_in_time
  s3_import = var.s3_import
  scaling_configuration = var.scaling_configuration
  serverlessv2_scaling_configuration = var.serverlessv2_scaling_configuration
  skip_final_snapshot = var.skip_final_snapshot
  snapshot_identifier = var.snapshot_identifier
  source_region = var.source_region
  storage_encrypted = var.storage_encrypted
  storage_type = var.storage_type
  cluster_tags = var.cluster_tags
  vpc_security_group_ids = var.vpc_security_group_ids
  cluster_timeouts = var.cluster_timeouts
  instances = var.instances
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  ca_cert_identifier = var.ca_cert_identifier
  db_parameter_group_name = var.db_parameter_group_name
  instances_use_identifier_prefix = var.instances_use_identifier_prefix
  instance_class = var.instance_class
  monitoring_interval = var.monitoring_interval
  performance_insights_enabled = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period
  publicly_accessible = var.publicly_accessible
  instance_timeouts = var.instance_timeouts
  endpoints = var.endpoints
  iam_roles = var.iam_roles
  create_monitoring_role = var.create_monitoring_role
  monitoring_role_arn = var.monitoring_role_arn
  iam_role_name = var.iam_role_name
  iam_role_use_name_prefix = var.iam_role_use_name_prefix
  iam_role_description = var.iam_role_description
  iam_role_path = var.iam_role_path
  iam_role_managed_policy_arns = var.iam_role_managed_policy_arns
  iam_role_permissions_boundary = var.iam_role_permissions_boundary
  iam_role_force_detach_policies = var.iam_role_force_detach_policies
  iam_role_max_session_duration = var.iam_role_max_session_duration
  autoscaling_enabled = var.autoscaling_enabled
  autoscaling_max_capacity = var.autoscaling_max_capacity
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_policy_name = var.autoscaling_policy_name
  predefined_metric_type = var.predefined_metric_type
  autoscaling_scale_in_cooldown = var.autoscaling_scale_in_cooldown
  autoscaling_scale_out_cooldown = var.autoscaling_scale_out_cooldown
  autoscaling_target_cpu = var.autoscaling_target_cpu
  autoscaling_target_connections = var.autoscaling_target_connections
  create_security_group = var.create_security_group
  security_group_name = var.security_group_name
  security_group_use_name_prefix = var.security_group_use_name_prefix
  security_group_description = var.security_group_description
  vpc_id = var.vpc_id
  security_group_rules = var.security_group_rules
  security_group_tags = var.security_group_tags
  create_db_cluster_parameter_group = var.create_db_cluster_parameter_group
  db_cluster_parameter_group_name = var.db_cluster_parameter_group_name
  db_cluster_parameter_group_use_name_prefix = var.db_cluster_parameter_group_use_name_prefix
  db_cluster_parameter_group_description = var.db_cluster_parameter_group_description
  db_cluster_parameter_group_family = var.db_cluster_parameter_group_family
  db_cluster_parameter_group_parameters = var.db_cluster_parameter_group_parameters
  create_db_parameter_group = var.create_db_parameter_group
  db_parameter_group_use_name_prefix = var.db_parameter_group_use_name_prefix
  db_parameter_group_description = var.db_parameter_group_description
  db_parameter_group_family = var.db_parameter_group_family
  db_parameter_group_parameters = var.db_parameter_group_parameters
  create_cloudwatch_log_group = var.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_kms_key_id = var.cloudwatch_log_group_kms_key_id
  cloudwatch_log_group_skip_destroy = var.cloudwatch_log_group_skip_destroy
  cloudwatch_log_group_class = var.cloudwatch_log_group_class
  create_db_cluster_activity_stream = var.create_db_cluster_activity_stream
  db_cluster_activity_stream_mode = var.db_cluster_activity_stream_mode
  db_cluster_activity_stream_kms_key_id = var.db_cluster_activity_stream_kms_key_id
  engine_native_audit_fields_included = var.engine_native_audit_fields_included
  manage_master_user_password_rotation = var.manage_master_user_password_rotation
  master_user_password_rotate_immediately = var.master_user_password_rotate_immediately
  master_user_password_rotation_automatically_after_days = var.master_user_password_rotation_automatically_after_days
  master_user_password_rotation_duration = var.master_user_password_rotation_duration
  master_user_password_rotation_schedule_expression = var.master_user_password_rotation_schedule_expression
}
