# Output info.
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "instance_ip" {
  value = module.ec2.ip_address
}

output "instance_url" {
  value = "https://${var.aws_region}.console.aws.amazon.com/ec2/home?region=us-west-2#InstanceDetails:instanceId=${module.ec2.instance_id}"
}
