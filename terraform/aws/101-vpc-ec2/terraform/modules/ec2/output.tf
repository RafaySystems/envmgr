output "ip_address"{
  value = module.ec2_instance.private_ip
}

data "aws_instance" "ec2_instance" {
  filter {
    name   = "tag:Name"
    values = ["module.ec2_instance.name"]
  }
}

output "instance_id"{
  value = data.aws_instance.ec2_instance.instance_id
}
