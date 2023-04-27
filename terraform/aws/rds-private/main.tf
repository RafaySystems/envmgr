/* For simplicity, this RDS tutorial instance is publicly accessible. 
Avoid configuring database instances in public subnets in production, since it increases the risk of security attacks.
*/

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
    values = ["rafay-${var.vpc_name}-cluster/VPC"]
  }
}

resource "aws_db_subnet_group" "subnet" {
  name       = "${var.name}-subnet"
  subnet_ids = data.aws_subnet_ids.selected.ids

  tags = {
    name = var.name
    email = var.email
    env = "dev"
  }
}

resource "aws_security_group" "rds" {
  name   = "${var.name}-rds"
  vpc_id = data.aws_vpc.selected.id

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
    email = var.email
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
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    name = var.name
    email = var.email
    env = "dev"
  }
}
