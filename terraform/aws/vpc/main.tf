module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = var.vpc_name
  cidr            = var.vpc_cidr
  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = [cidrsubnet(var.vpc_cidr, 8, 1), cidrsubnet(var.vpc_cidr, 8, 2), cidrsubnet(var.vpc_cidr, 8, 3)]
  public_subnets  = [cidrsubnet(var.vpc_cidr, 8, 100), cidrsubnet(var.vpc_cidr, 8, 101), cidrsubnet(var.vpc_cidr, 8, 102)]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true
  enable_dns_support     = true

  tags = merge({
    "Name" = var.vpc_name, "cluster-name" = var.vpc_name },
  var.tags)
}

