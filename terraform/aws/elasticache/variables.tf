variable "region" {
  default     = "us-west-2"
  description = "AWS region"
}

variable "cluster_id" {
    default = "nirav-envmgr-ec"
    description = "Elasticache cluster ID"
}

variable "email" {
  description = "Email tag to be added while creating the resource"
}