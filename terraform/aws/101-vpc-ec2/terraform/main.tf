resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

locals {

instance_type = var.instance_map[index(var.instance_map.*.id, "var.compute")]
 #instance_type = var.compute == "2 vCPU, 2 GiB Memory" ? t3.small : false
 #instance_type = var.compute == "2 vCPU, 4 GiB Memory" ? t3.medium : false
 #instance_type = var.compute == "2 vCPU, 8 GiB Memory" ? t3.large : false
 #instance_type = var.compute == "4 vCPU, 16 GiB Memory" ? t3.xlarge : false
 #instance_type = var.compute == "8 vCPU, 32 GiB Memory" ? t3.2xlarge : false
}

module "vpc" {
  source     = "./modules/vpc"
  vpc_cidr   = var.vpc_cidr
  aws_region = var.aws_region
  prefix     = random_string.resource_code.result
}

module "ec2" {
  source        = "./modules/ec2"
  instance_type = local.instance_type
  subnet_id     = module.vpc.private_subnets[0]
  prefix        = random_string.resource_code.result
}
