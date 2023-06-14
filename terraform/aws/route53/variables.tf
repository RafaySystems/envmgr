variable "region" {
  default     = "us-west-2"
  description = "AWS region"
}

variable "zone_name" {
  description = "route 53 zone name"
}

variable "sub_domain" {
  default = "www"
  description = "sub domain"
}

variable "cname" {
  description = "cname"
}

