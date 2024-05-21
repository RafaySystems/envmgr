module "terraform-aws-route53" {
  source  = "terraform-aws-route53//modules/zones"
  version = "2.11.1"

  create = var.create
  zones = var.zones
  tags = var.tags
}
