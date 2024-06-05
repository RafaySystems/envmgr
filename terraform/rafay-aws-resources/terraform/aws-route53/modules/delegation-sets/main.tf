module "route53_delegation-sets" {
  source  = "terraform-aws-route53/route53/aws//modules/delegation-sets"
  version = "2.11.1"

  create = var.create
  delegation_sets = var.delegation_sets
}
