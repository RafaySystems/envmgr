module "cloudwatch_metric-stream" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-stream"
  version = "5.3.1"

  create = var.create
  name = var.name
  name_prefix = var.name_prefix
  firehose_arn = var.firehose_arn
  role_arn = var.role_arn
  output_format = var.output_format
  exclude_filter = var.exclude_filter
  include_filter = var.include_filter
  statistics_configuration = var.statistics_configuration
  tags = var.tags
}
