resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

module "vpc" {
  source     = "./modules/vpc"
  vpc_cidr   = var.vpc_cidr
  aws_region = var.aws_region
  prefix     = random_string.resource_code.result
}

module "ec2" {
  source        = "./modules/ec2"
  instance_type = var.instance_type
  subnet_id     = module.vpc.private_subnets[0]
  prefix        = random_string.resource_code.result
}
