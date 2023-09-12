provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      env = "dev"
      email       = "nirav.parikh@rafay.co"
    }
  }
}

resource "aws_instance" "ubuntu" {
  ami           = var.ami_id
  instance_type = var.instance_type
  availability_zone = var.aws_region_az

  tags = {
    Name = var.name
    env = "dev"
    email       = "nirav.parikh@rafay.co"
  }
  volume_tags = {
    env = "dev"
    email       = "nirav.parikh@rafay.co"
  }
}

resource "aws_instance" "ubuntu2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  availability_zone = var.aws_region_az

  tags = {
    Name = var.instance2_name
    env = "dev"
    email       = "nirav.parikh@rafay.co"
  }
  volume_tags = {
    env = "dev"
    email       = "nirav.parikh@rafay.co"
  }
}
