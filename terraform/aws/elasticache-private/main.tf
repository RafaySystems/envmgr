provider "aws" {
  region = var.region
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name = "map-public-ip-on-launch"
    values = [false]
  }
}


data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["${var.vpc_name}"]
  }
}

resource "aws_elasticache_subnet_group" "subnet" {
  name       = "${var.cluster_id}-subnet"
  subnet_ids = data.aws_subnet_ids.selected.ids

  tags = {
    name = var.cluster_id
    email = var.email
    env = "dev"
  }
}

resource "aws_security_group" "ec_sg" {
  name   = "${var.cluster_id}-ec_sg"
  vpc_id = data.aws_vpc.selected.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = var.cluster_id
    email = var.email
    env = "dev"
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.cluster_id
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.subnet.name
  security_group_ids   = [aws_security_group.ec_sg.id]


  tags = {
    name = var.cluster_id
    email = var.email
    env = "dev"
  }
}