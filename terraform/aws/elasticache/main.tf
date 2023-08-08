provider "aws" {
  region = var.region
}

// can be externalized as a shared / static resource
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name                 = "${var.cluster_id}-vpc"
  cidr                 = "10.0.0.0/16" // can be externalized as input var
  azs                  = ["${var.region}a", "${var.region}b", "${var.region}c"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = var.cluster_id
    email = var.email
    env = "dev"
  }
}

resource "aws_elasticache_subnet_group" "subnet" {
  name       = "${var.cluster_id}-subnet"
  subnet_ids = module.vpc.public_subnets

  tags = {
    name = var.cluster_id
    email = var.email
    env = "dev"
  }
}

resource "aws_security_group" "ec_sg" {
  name   = "${var.cluster_id}-ec_sg"
  vpc_id = module.vpc.vpc_id

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
