variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "ec_name" {
  description = "Elasticache Name"
  default     = "example-elasticache-serverless"
  type        = string
}

variable "engine" {
  description = "Elasticache Engine"
  type        = string
  default     = "redis"
}

variable "engine_version" {
  description = "Elasticache Version"
  type        = string
  default     = "7"
}

variable "tags" {
  description = "AWS Tags"
  type        = map(string)
  default = {
    "env" = "qa"
  }
}

variable "kms_key_id" {
  description = "KMS Key ID"
  type        = string
  default     = ""
}

variable "data_storage_limits_min" {
  type    = number
  default = 10
}

variable "data_storage_limits_max" {
  type    = number
  default = 100
}

variable "ecpu_per_second_min" {
  type    = number
  default = 1000
}

variable "ecpu_per_second_max" {
  type    = number
  default = 5000
}

variable "daily_snapshot_time" {
  type    = string
  default = null
}

variable "snapshot_retention_limit" {
  type    = number
  default = null
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "subnet_ids" {
  type = list(string)
}

variable "account_id" {
  type    = string
  default = ""
}

variable "role_name" {
  type    = string
  default = ""
}
