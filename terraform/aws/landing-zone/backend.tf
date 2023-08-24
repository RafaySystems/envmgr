terraform {
  backend "s3" {
    bucket         = "km-tf-eks"
    key            = "km-lz"
    region         = "us-west-2"
    encrypt        = true
  }
}