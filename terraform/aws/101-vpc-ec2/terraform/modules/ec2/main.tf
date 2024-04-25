module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "em-ec2-${var.prefix}"

  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  ami                    = var.ami_id

  tags = {
      Name = "em-ec2-${var.prefix}"
      email = "hardik@rafay.co"
      env   = "qa"
  }
  volume_tags = {
      Name = "em-ec2-vol-${var.prefix}"
      email = "hardik@rafay.co"
      env   = "qa"
  }
}
