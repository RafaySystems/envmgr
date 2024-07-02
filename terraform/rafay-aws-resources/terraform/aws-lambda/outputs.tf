output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.terraform-aws-lambda.lambda_function_arn
}

output "lambda_function_arn_static" {
  description = "The static ARN of the Lambda Function. Use this to avoid cycle errors between resources (e.g., Step Functions)"
  value       = module.terraform-aws-lambda.lambda_function_arn_static
}

output "lambda_function_invoke_arn" {
  description = "The Invoke ARN of the Lambda Function"
  value       = module.terraform-aws-lambda.lambda_function_invoke_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = module.terraform-aws-lambda.lambda_function_name
}

output "lambda_function_qualified_arn" {
  description = "The ARN identifying your Lambda Function Version"
  value       = module.terraform-aws-lambda.lambda_function_qualified_arn
}

output "lambda_function_qualified_invoke_arn" {
  description = "The Invoke ARN identifying your Lambda Function Version"
  value       = module.terraform-aws-lambda.lambda_function_qualified_invoke_arn
}

output "lambda_function_version" {
  description = "Latest published version of Lambda Function"
  value       = module.terraform-aws-lambda.lambda_function_version
}

output "lambda_function_last_modified" {
  description = "The date Lambda Function resource was last modified"
  value       = module.terraform-aws-lambda.lambda_function_last_modified
}

output "lambda_function_kms_key_arn" {
  description = "The ARN for the KMS encryption key of Lambda Function"
  value       = module.terraform-aws-lambda.lambda_function_kms_key_arn
}

output "lambda_function_source_code_hash" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file"
  value       = module.terraform-aws-lambda.lambda_function_source_code_hash
}

output "lambda_function_source_code_size" {
  description = "The size in bytes of the function .zip file"
  value       = module.terraform-aws-lambda.lambda_function_source_code_size
}

output "lambda_function_signing_job_arn" {
  description = "ARN of the signing job"
  value       = module.terraform-aws-lambda.lambda_function_signing_job_arn
}

output "lambda_function_signing_profile_version_arn" {
  description = "ARN of the signing profile version"
  value       = module.terraform-aws-lambda.lambda_function_signing_profile_version_arn
}

output "lambda_function_url" {
  description = "The URL of the Lambda Function URL"
  value       = module.terraform-aws-lambda.lambda_function_url
}

output "lambda_function_url_id" {
  description = "The Lambda Function URL generated id"
  value       = module.terraform-aws-lambda.lambda_function_url_id
}

output "lambda_layer_arn" {
  description = "The ARN of the Lambda Layer with version"
  value       = module.terraform-aws-lambda.lambda_layer_arn
}

output "lambda_layer_layer_arn" {
  description = "The ARN of the Lambda Layer without version"
  value       = module.terraform-aws-lambda.lambda_layer_layer_arn
}

output "lambda_layer_created_date" {
  description = "The date Lambda Layer resource was created"
  value       = module.terraform-aws-lambda.lambda_layer_created_date
}

output "lambda_layer_source_code_size" {
  description = "The size in bytes of the Lambda Layer .zip file"
  value       = module.terraform-aws-lambda.lambda_layer_source_code_size
}

output "lambda_layer_version" {
  description = "The Lambda Layer version"
  value       = module.terraform-aws-lambda.lambda_layer_version
}

output "lambda_event_source_mapping_function_arn" {
  description = "The the ARN of the Lambda function the event source mapping is sending events to"
  value       = module.terraform-aws-lambda.lambda_event_source_mapping_function_arn
}

output "lambda_event_source_mapping_state" {
  description = "The state of the event source mapping"
  value       = module.terraform-aws-lambda.lambda_event_source_mapping_state
}

output "lambda_event_source_mapping_state_transition_reason" {
  description = "The reason the event source mapping is in its current state"
  value       = module.terraform-aws-lambda.lambda_event_source_mapping_state_transition_reason
}

output "lambda_event_source_mapping_uuid" {
  description = "The UUID of the created event source mapping"
  value       = module.terraform-aws-lambda.lambda_event_source_mapping_uuid
}

output "lambda_role_arn" {
  description = "The ARN of the IAM role created for the Lambda Function"
  value       = module.terraform-aws-lambda.lambda_role_arn
}

output "lambda_role_name" {
  description = "The name of the IAM role created for the Lambda Function"
  value       = module.terraform-aws-lambda.lambda_role_name
}

output "lambda_role_unique_id" {
  description = "The unique id of the IAM role created for the Lambda Function"
  value       = module.terraform-aws-lambda.lambda_role_unique_id
}

output "lambda_cloudwatch_log_group_arn" {
  description = "The ARN of the Cloudwatch Log Group"
  value       = module.terraform-aws-lambda.lambda_cloudwatch_log_group_arn
}

output "lambda_cloudwatch_log_group_name" {
  description = "The name of the Cloudwatch Log Group"
  value       = module.terraform-aws-lambda.lambda_cloudwatch_log_group_name
}

output "local_filename" {
  description = "The filename of zip archive deployed (if deployment was from local)"
  value       = module.terraform-aws-lambda.local_filename
}

output "s3_object" {
  description = "The map with S3 object data of zip archive deployed (if deployment was from S3)"
  value       = module.terraform-aws-lambda.s3_object
}

