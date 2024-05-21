module "terraform-aws-route53" {
  source  = "terraform-aws-route53//modules/delegation-sets"
  version = "2.11.1"

  create = var.create
  delegation_sets = var.delegation_sets
}
