output "route53_resolver_rule_association_id" {
  description = "ID of Route53 Resolver rule associations"
  value       = module.terraform-aws-route53.route53_resolver_rule_association_id
}

output "route53_resolver_rule_association_name" {
  description = "Name of Route53 Resolver rule associations"
  value       = module.terraform-aws-route53.route53_resolver_rule_association_name
}

output "route53_resolver_rule_association_resolver_rule_id" {
  description = "ID of Route53 Resolver rule associations resolver rule"
  value       = module.terraform-aws-route53.route53_resolver_rule_association_resolver_rule_id
}

