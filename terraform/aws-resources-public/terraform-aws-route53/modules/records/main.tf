module "terraform-aws-route53" {
  source  = "terraform-aws-route53//modules/records"
  version = "2.11.1"

  create = var.create
  zone_id = var.zone_id
  zone_name = var.zone_name
  private_zone = var.private_zone
  records = var.records
  records_jsonencoded = var.records_jsonencoded
}
