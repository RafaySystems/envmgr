output "lambda_alias_name" {
  description = "The name of the Lambda Function Alias"
  value       = module.terraform-aws-lambda.lambda_alias_name
}

output "lambda_alias_arn" {
  description = "The ARN of the Lambda Function Alias"
  value       = module.terraform-aws-lambda.lambda_alias_arn
}

output "lambda_alias_invoke_arn" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway"
  value       = module.terraform-aws-lambda.lambda_alias_invoke_arn
}

output "lambda_alias_description" {
  description = "Description of alias"
  value       = module.terraform-aws-lambda.lambda_alias_description
}

output "lambda_alias_function_version" {
  description = "Lambda function version which the alias uses"
  value       = module.terraform-aws-lambda.lambda_alias_function_version
}

output "lambda_alias_event_source_mapping_function_arn" {
  description = "The the ARN of the Lambda function the event source mapping is sending events to"
  value       = module.terraform-aws-lambda.lambda_alias_event_source_mapping_function_arn
}

output "lambda_alias_event_source_mapping_state" {
  description = "The state of the event source mapping"
  value       = module.terraform-aws-lambda.lambda_alias_event_source_mapping_state
}

output "lambda_alias_event_source_mapping_state_transition_reason" {
  description = "The reason the event source mapping is in its current state"
  value       = module.terraform-aws-lambda.lambda_alias_event_source_mapping_state_transition_reason
}

output "lambda_alias_event_source_mapping_uuid" {
  description = "The UUID of the created event source mapping"
  value       = module.terraform-aws-lambda.lambda_alias_event_source_mapping_uuid
}

