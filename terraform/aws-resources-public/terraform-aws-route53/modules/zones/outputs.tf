output "route53_zone_zone_id" {
  description = "Zone ID of Route53 zone"
  value       = module.terraform-aws-route53.route53_zone_zone_id
}

output "route53_zone_zone_arn" {
  description = "Zone ARN of Route53 zone"
  value       = module.terraform-aws-route53.route53_zone_zone_arn
}

output "route53_zone_name_servers" {
  description = "Name servers of Route53 zone"
  value       = module.terraform-aws-route53.route53_zone_name_servers
}

output "route53_zone_name" {
  description = "Name of Route53 zone"
  value       = module.terraform-aws-route53.route53_zone_name
}

output "route53_static_zone_name" {
  description = "Name of Route53 zone created statically to avoid invalid count argument error when creating records and zones simmultaneously"
  value       = module.terraform-aws-route53.route53_static_zone_name
}

