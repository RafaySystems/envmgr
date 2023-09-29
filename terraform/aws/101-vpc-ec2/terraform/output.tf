# Output info.
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "instance_ip" {
  value = module.ec2.ip_address
}
