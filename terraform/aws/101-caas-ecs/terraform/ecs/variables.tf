variable "region" {
  default     = "us-east-1"
  description = "AWS region for resources deployment"
  type        = string
}
variable "vpc_id" {
  default     = "Replace with the VPC ID"
  description = "VPC ID"
  type        = string
}
variable "public_subnet_id" {
  default     = ["Replace with the Subnet in which the Fargate should run"]
  description = "Public Subnet ID"
}
variable "name" {
  default     = "app-caas-ecs"
  description = "App Name"
  type        = string
}
variable "container_name" {
  default     = "container-caas-ecs"
  description = "Container Name"
  type        = string
}
variable "ecs_task_definition_name" {
    type = string
    default = "app-task-caas-ecs"
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
  default     = "dev"
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

