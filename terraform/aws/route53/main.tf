provider "aws" {
  region = var.region
}

data "aws_route53_zone" "selected" {
  name = var.zone_name
}

resource "aws_route53_record" "cname_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.sub_domain
  type    = "CNAME"
  ttl     = "60"
  records = [var.cname]
}

