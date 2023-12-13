variable "region" {
  description = "AWS region for resources deployment"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "public_subnet_id" {
  description = "Public Subnet ID"
}
variable "name" {
  description = "App Name"
  type        = string
}
variable "container_name" {
  description = "Container Name"
  type        = string
}
variable "ecs_task_definition_name" {
    type = string
    description = "Task definition name"
}
variable "image_location" {
  default     = "public.ecr.aws/ecs-sample-image/amazon-ecs-sample:latest"
  description = "Container Image location"
  type        = string
}
variable "container_port" {
  default     = "80"
  description = "Container Port"
  type        = number
}
variable "environment" {
  description = "App Environment Name"
  type        = string
}
variable "tags" {
  default = {
    ProjectName = "Replace with the Project Name tag if you wish to keep"
    ResourceName  = "Replace with the Email address tag if you wish to keep"
  }
  description = "Default tags for all resources"
  type        = map(string)
}

