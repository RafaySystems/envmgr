output "image_uri" {
  description = "The ECR image URI for deploying lambda"
  value       = module.terraform-aws-lambda.image_uri
}

output "image_id" {
  description = "The ID of the Docker image"
  value       = module.terraform-aws-lambda.image_id
}

