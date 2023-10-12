variable "region" {
  default     = "us-west-2"
  description = "AWS region"
}

variable "bucketname" {
    default = "envmgr-demo-bucket"
    description = "S3 Bucket name"
}

variable "email" {
  description = "Email tag to be added while creating the resource"
    default = "test@rafay.co"
}

variable "name" {
  description = "Creators name tag to be added while creating the resource"
    default = "test namr"
}
