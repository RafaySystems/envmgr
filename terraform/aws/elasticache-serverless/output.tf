output "elasticache_address" {
  value = resource.aws_elasticache_serverless_cache.example.reader_endpoint[0].address
}

output "elasticache_port" {
  value = resource.aws_elasticache_serverless_cache.example.reader_endpoint[0].port
}
