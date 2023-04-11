/* For simplicity, this RDS tutorial instance is publicly accessible. 
Avoid configuring database instances in public subnets in production, since it increases the risk of security attacks.
*/

provider "aws" {
  region = var.region
}

// can be externalized as a shared / static resource
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "${var.name}"
  cidr                 = "10.0.0.0/16" // can be externalized as input var
  azs                  = ["${var.region}a", "${var.region}b", "${var.region}c"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = var.name
    email = var.email
    env = "dev"
  }
}

