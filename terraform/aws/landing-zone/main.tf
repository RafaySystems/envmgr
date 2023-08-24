provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name                 = "${var.name}"
  cidr                 = "${var.cidr}"
  secondary_cidr_blocks = "${var.secondary_cidr_blocks}"
  azs                  = local.azs
  private_subnets     = concat(
    [for k, v in local.azs : cidrsubnet("${var.cidr}", 8, k)],
    [for k, v in local.azs : cidrsubnet(element("${var.secondary_cidr_blocks}", 0), 2, k)]
   )
  public_subnets      = [for k, v in local.azs : cidrsubnet("${var.cidr}", 8, k + 4)]
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = {
    name = var.name
    email = var.email
    env = var.env
  }
}

