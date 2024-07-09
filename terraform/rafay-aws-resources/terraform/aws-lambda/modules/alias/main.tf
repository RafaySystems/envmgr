module "terraform-aws-lambda" {
  source  = "terraform-aws-lambda//modules/alias"
  version = "7.7.0"

  create = var.create
  use_existing_alias = var.use_existing_alias
  refresh_alias = var.refresh_alias
  create_async_event_config = var.create_async_event_config
  create_version_async_event_config = var.create_version_async_event_config
  create_qualified_alias_async_event_config = var.create_qualified_alias_async_event_config
  create_version_allowed_triggers = var.create_version_allowed_triggers
  create_qualified_alias_allowed_triggers = var.create_qualified_alias_allowed_triggers
  name = var.name
  description = var.description
  function_name = var.function_name
  function_version = var.function_version
  routing_additional_version_weights = var.routing_additional_version_weights
  maximum_event_age_in_seconds = var.maximum_event_age_in_seconds
  maximum_retry_attempts = var.maximum_retry_attempts
  destination_on_failure = var.destination_on_failure
  destination_on_success = var.destination_on_success
  allowed_triggers = var.allowed_triggers
  event_source_mapping = var.event_source_mapping
}
