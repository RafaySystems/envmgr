resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

locals {
 instance_type = lookup(var.instance_map, var.compute, "")
 ami = lookup(var.ami_map, var.guest_os_version, "")
}

module "vpc" {
  source     = "./modules/vpc"
  vpc_cidr   = var.vpc_cidr
  aws_region = var.aws_region
  storage_size = var.storage
  prefix     = random_string.resource_code.result
}

module "ec2" {
  source        = "./modules/ec2"
  instance_type = local.instance_type
  subnet_id     = module.vpc.private_subnets[0]
  ami_id        = local.ami
  prefix        = random_string.resource_code.result
}
