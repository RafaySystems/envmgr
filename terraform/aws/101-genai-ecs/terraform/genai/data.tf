data "aws_region" "current_region" {}
data "aws_caller_identity" "current_account" {}
data "aws_ecr_authorization_token" "token" {}
data "aws_vpc" "app-vpc" {
  id = var.vpc_id
}
# Public IP of the ECS Service.
data "aws_network_interface" "ip" {
  depends_on = [time_sleep.wait_60_seconds]
  filter {
    name   = "subnet-id"
    values = var.public_subnet_id
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.app-vpc.id]
  }
  filter {
    name   = "group-id"
    values = [aws_security_group.ecs_tasks.id]
  }
}
