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


