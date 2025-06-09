variable "username" {
  description = "Name of User"
  type        = string
  default = "tim@rafay.co"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default = "us-east-1"
}

variable "domain_id" {
  description = "Sagemaker Domain ID"
  type        = string
  default = "d-lwyjawvc4zc3"
}

variable "execution_role_arn" {
  description = "Sagemaker Domain Execution Role ARN"
  type        = string
  default = "arn:aws:iam::679196758854:role/service-role/AmazonSageMaker-ExecutionRole-20250404T164231"
}

 variable hidden_instance_types {
default = [
    "ml.c6id.16xlarge", "ml.c6id.24xlarge", "ml.c6id.32xlarge", "ml.r6id.large", "ml.r6id.xlarge", "ml.r6id.2xlarge",
    "ml.r6id.4xlarge", "ml.r6id.8xlarge", "ml.r6id.12xlarge", "ml.r6id.16xlarge", "ml.r6id.24xlarge", "ml.r6id.32xlarge"
  ]
}
