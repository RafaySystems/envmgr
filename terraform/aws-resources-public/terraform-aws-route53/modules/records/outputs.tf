output "route53_record_name" {
  description = "The name of the record"
  value       = module.route53_records.route53_record_name
}

output "route53_record_fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = module.route53_records.route53_record_fqdn
}

