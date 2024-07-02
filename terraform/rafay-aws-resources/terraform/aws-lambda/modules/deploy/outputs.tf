output "codedeploy_app_name" {
  description = "Name of CodeDeploy application"
  value       = module.terraform-aws-lambda.codedeploy_app_name
}

output "codedeploy_deployment_group_name" {
  description = "CodeDeploy deployment group name"
  value       = module.terraform-aws-lambda.codedeploy_deployment_group_name
}

output "codedeploy_deployment_group_id" {
  description = "CodeDeploy deployment group id"
  value       = module.terraform-aws-lambda.codedeploy_deployment_group_id
}

output "codedeploy_iam_role_name" {
  description = "Name of IAM role used by CodeDeploy"
  value       = module.terraform-aws-lambda.codedeploy_iam_role_name
}

output "appspec" {
  description = "Appspec data as HCL"
  value       = module.terraform-aws-lambda.appspec
}

output "appspec_content" {
  description = "Appspec data as valid JSON"
  value       = module.terraform-aws-lambda.appspec_content
}

output "appspec_sha256" {
  description = "SHA256 of Appspec JSON"
  value       = module.terraform-aws-lambda.appspec_sha256
}

output "script" {
  description = "Deployment script"
  value       = module.terraform-aws-lambda.script
}

output "deploy_script" {
  description = "Path to a deployment script"
  value       = module.terraform-aws-lambda.deploy_script
}

