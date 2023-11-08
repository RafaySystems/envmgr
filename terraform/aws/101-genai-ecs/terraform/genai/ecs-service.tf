resource "aws_ecs_service" "main" {
 name                               = "${var.name}-service-${var.environment}-${var.vpc_id}"
 tags                               = var.tags
 cluster                            = aws_ecs_cluster.cluster.id
 task_definition                    = aws_ecs_task_definition.main.arn
 desired_count                      = 1
 deployment_minimum_healthy_percent = 0
 deployment_maximum_percent         = 100
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"

force_new_deployment = true
 
 network_configuration {
   security_groups  = [ aws_security_group.ecs_tasks.id ]
   subnets          = var.public_subnet_id
   assign_public_ip = true
 }
 
 lifecycle {
   ignore_changes = [desired_count]
 }
}

resource "time_sleep" "wait_60_seconds" {
  depends_on      = [aws_ecs_service.main]
  create_duration = "60s"

  triggers = {
    task_arn = aws_ecs_task_definition.main.arn
  }
}
