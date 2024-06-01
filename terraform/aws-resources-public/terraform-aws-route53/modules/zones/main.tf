module "route53_zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "2.11.1"

  create = var.create
  zones = var.zones
  tags = var.tags
}
