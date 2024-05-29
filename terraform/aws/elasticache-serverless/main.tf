resource "aws_elasticache_serverless_cache" "example" {
  engine = var.engine
  name   = var.ec_name
  cache_usage_limits {
    data_storage {
      minimum = var.data_storage_limits_min
      maximum = var.data_storage_limits_max
      unit    = "GB"
    }
    ecpu_per_second {
      minimum = var.ecpu_per_second_min
      maximum = var.ecpu_per_second_max
    }
  }
  major_engine_version     = var.engine_version
  daily_snapshot_time      = try(var.daily_snapshot_time, null)
  snapshot_retention_limit = try(var.snapshot_retention_limit, null)
  security_group_ids       = length(var.security_group_ids) > 0 ? var.security_group_ids : null
  subnet_ids               = var.subnet_ids
  tags                     = var.tags
}

