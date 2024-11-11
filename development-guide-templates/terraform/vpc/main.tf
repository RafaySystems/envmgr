module "vpc" {
 source = "terraform-aws-modules/vpc/aws"


 name = var.vpc_name
 cidr = var.vpc_cidr


 azs             = ["${var.aws_region}a"]
 private_subnets = [cidrsubnet(var.vpc_cidr, 8, 1)]
 public_subnets  = [cidrsubnet(var.vpc_cidr, 8, 100)]


 enable_nat_gateway     = true
 single_nat_gateway     = true
 one_nat_gateway_per_az = false


 tags = var.tags
}
