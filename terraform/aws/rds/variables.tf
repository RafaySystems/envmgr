variable "region" {
  default     = "us-west-2"
  description = "AWS region"
}

variable "db_username" {
  default     = "adminuser"
  description = "RDS root username"
}

variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
}

variable "name" {
    default = "nirav-envmgr-rds"
    description = "RDS resource name"
}