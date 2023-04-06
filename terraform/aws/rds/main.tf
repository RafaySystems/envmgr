/* For simplicity, this RDS tutorial instance is publicly accessible. 
Avoid configuring database instances in public subnets in production, since it increases the risk of security attacks.
*/

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

// can be externalized as a shared / static resource
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "${var.name}-vpc"
  cidr                 = "10.0.0.0/16" // can be externalized as input var
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = var.name
    email = "nirav.parikh@rafay.co"
    env = "dev"
  }
}

resource "aws_db_subnet_group" "subnet" {
  name       = "${var.name}-subnet"
  subnet_ids = module.vpc.public_subnets

  tags = {
    name = var.name
    email = "nirav.parikh@rafay.co"
    env = "dev"
  }
}

resource "aws_security_group" "rds" {
  name   = "${var.name}-rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = var.name
    email = "nirav.parikh@rafay.co"
    env = "dev"
  }
}

resource "aws_db_instance" "db" {
  identifier             = var.name
  instance_class         = "db.t3.medium"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.1"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.subnet.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = true
  skip_final_snapshot    = true

  tags = {
    name = var.name
    email = "nirav.parikh@rafay.co"
    env = "dev"
  }
}