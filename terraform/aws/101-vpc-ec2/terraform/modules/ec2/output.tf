output "ip_address"{
  value = module.ec2_instance.private_ip
}

output "instance_id"{
  value = module.ec2_instance.id
}
