provider "aws" {
  region = var.region
}

resource "aws_security_group" "lb_sg" {
  name   = "${var.name}-lb_sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = var.name
    email = "nirav.parikh@rafay.co"
    env = "dev"
  }
}

resource "aws_lb" "lb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  tags = {
    name = var.name
    email = "nirav.parikh@rafay.co"
    env = "dev"
  }
}