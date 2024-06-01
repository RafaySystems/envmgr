output "route53_delegation_set_id" {
  description = "ID of Route53 delegation set"
  value       = module.route53_delegation-sets.route53_delegation_set_id
}

output "route53_delegation_set_name_servers" {
  description = "Name servers in the Route53 delegation set"
  value       = module.route53_delegation-sets.route53_delegation_set_name_servers
}

output "route53_delegation_set_reference_name" {
  description = "Reference name used when the Route53 delegation set has been created"
  value       = module.route53_delegation-sets.route53_delegation_set_reference_name
}

