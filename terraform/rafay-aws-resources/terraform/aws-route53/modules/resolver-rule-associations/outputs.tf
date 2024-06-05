output "route53_resolver_rule_association_id" {
  description = "ID of Route53 Resolver rule associations"
  value       = module.route53_resolver-rule-associations.route53_resolver_rule_association_id
}

output "route53_resolver_rule_association_name" {
  description = "Name of Route53 Resolver rule associations"
  value       = module.route53_resolver-rule-associations.route53_resolver_rule_association_name
}

output "route53_resolver_rule_association_resolver_rule_id" {
  description = "ID of Route53 Resolver rule associations resolver rule"
  value       = module.route53_resolver-rule-associations.route53_resolver_rule_association_resolver_rule_id
}

