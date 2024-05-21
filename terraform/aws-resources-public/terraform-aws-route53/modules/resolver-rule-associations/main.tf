module "terraform-aws-route53" {
  source  = "terraform-aws-route53//modules/resolver-rule-associations"
  version = "2.11.1"

  create = var.create
  vpc_id = var.vpc_id
  resolver_rule_associations = var.resolver_rule_associations
}
