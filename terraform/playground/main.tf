variable "vpc_name" {}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name = "map-public-ip-on-launch"
    values = [false]
  }
}


data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["${var.vpc_name}"]
  }
}

output "vpc_id" {
  value = data.aws_vpc.selected.id
}

output "vpc_arn" {
  value = data.aws_vpc.selected.arn
}

output "vpc_subnets" {
  value = data.aws_subnet_ids.selected.ids
}
