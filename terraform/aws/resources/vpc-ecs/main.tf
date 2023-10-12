### VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "subnet_route" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg" {
  name   = "${var.vpc_name}ecs-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = "false"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "${var.vpc_name}-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = 512
  memory                   = 2048
  container_definitions    = <<DEFINITION
  [
    {
      "name"      : "nginx",
      "image"     : "nginx:1.23.1",
      "cpu"       : 512,
      "memory"    : 2048,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort"      : 80
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "service" {
  name             = "${var.vpc_name}-service"
  cluster          = aws_ecs_cluster.cluster.id
  task_definition  = aws_ecs_task_definition.task.id
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.sg.id]
    subnets          = [aws_subnet.subnet.id]
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on      = [aws_ecs_service.service]
  create_duration = "30s"
}


# Public IP of the ECS Service.
data "aws_network_interface" "ip" {
  depends_on = [time_sleep.wait_30_seconds]
  filter {
    name   = "subnet-id"
    values = [aws_subnet.subnet.id]
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }
  filter {
    name   = "group-id"
    values = [aws_security_group.sg.id]
  }
}
