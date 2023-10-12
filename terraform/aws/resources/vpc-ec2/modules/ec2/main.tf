module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "eaas-demo-ec2-${var.prefix}"

  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = {
    Name  = "eaas-demo-ec2-${var.prefix}"
    email = "hardik@rafay.co"
    env   = "demo"
  }
  volume_tags = {
    Name  = "eaas-demo-ec2-vol-${var.prefix}"
    email = "hardik@rafay.co"
    env   = "demo"
  }
}
