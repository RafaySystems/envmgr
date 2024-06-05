output "id" {
  description = "The ID of the instance"
  value       = module.terraform-aws-ec2-instance.id
}

output "arn" {
  description = "The ARN of the instance"
  value       = module.terraform-aws-ec2-instance.arn
}

output "capacity_reservation_specification" {
  description = "Capacity reservation specification of the instance"
  value       = module.terraform-aws-ec2-instance.capacity_reservation_specification
}

output "instance_state" {
  description = "The state of the instance"
  value       = module.terraform-aws-ec2-instance.instance_state
}

output "outpost_arn" {
  description = "The ARN of the Outpost the instance is assigned to"
  value       = module.terraform-aws-ec2-instance.outpost_arn
}

output "password_data" {
  description = "Base-64 encoded encrypted password data for the instance. Useful for getting the administrator password for instances running Microsoft Windows. This attribute is only exported if `get_password_data` is true"
  value       = module.terraform-aws-ec2-instance.password_data
}

output "primary_network_interface_id" {
  description = "The ID of the instance's primary network interface"
  value       = module.terraform-aws-ec2-instance.primary_network_interface_id
}

output "private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = module.terraform-aws-ec2-instance.private_dns
}

output "public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = module.terraform-aws-ec2-instance.public_dns
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.terraform-aws-ec2-instance.public_ip
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value       = module.terraform-aws-ec2-instance.private_ip
}

output "ipv6_addresses" {
  description = "The IPv6 address assigned to the instance, if applicable"
  value       = module.terraform-aws-ec2-instance.ipv6_addresses
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = module.terraform-aws-ec2-instance.tags_all
}

output "spot_bid_status" {
  description = "The current bid status of the Spot Instance Request"
  value       = module.terraform-aws-ec2-instance.spot_bid_status
}

output "spot_request_state" {
  description = "The current request state of the Spot Instance Request"
  value       = module.terraform-aws-ec2-instance.spot_request_state
}

output "spot_instance_id" {
  description = "The Instance ID (if any) that is currently fulfilling the Spot Instance request"
  value       = module.terraform-aws-ec2-instance.spot_instance_id
}

output "ami" {
  description = "AMI ID that was used to create the instance"
  value       = module.terraform-aws-ec2-instance.ami
}

output "availability_zone" {
  description = "The availability zone of the created instance"
  value       = module.terraform-aws-ec2-instance.availability_zone
}

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = module.terraform-aws-ec2-instance.iam_role_name
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = module.terraform-aws-ec2-instance.iam_role_arn
}

output "iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = module.terraform-aws-ec2-instance.iam_role_unique_id
}

output "iam_instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  value       = module.terraform-aws-ec2-instance.iam_instance_profile_arn
}

output "iam_instance_profile_id" {
  description = "Instance profile's ID"
  value       = module.terraform-aws-ec2-instance.iam_instance_profile_id
}

output "iam_instance_profile_unique" {
  description = "Stable and unique string identifying the IAM instance profile"
  value       = module.terraform-aws-ec2-instance.iam_instance_profile_unique
}

output "root_block_device" {
  description = "Root block device information"
  value       = module.terraform-aws-ec2-instance.root_block_device
}

output "ebs_block_device" {
  description = "EBS block device information"
  value       = module.terraform-aws-ec2-instance.ebs_block_device
}

output "ephemeral_block_device" {
  description = "Ephemeral block device information"
  value       = module.terraform-aws-ec2-instance.ephemeral_block_device
}

