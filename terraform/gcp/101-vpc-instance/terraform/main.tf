resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}


module "gcp-vnet" {
  source        = "./modules/vnet"
  project_id    = var.project_id
  ip_cidr_range = var.ip_cidr_range
  prefix        = random_string.resource_code.result
}

module "gcp-instance" {
  source       = "./modules/instance"
  project_id   = var.project_id
  subnetwork   = module.gcp-vnet.subnetwork
  machine_type = var.machine_type
  prefix       = random_string.resource_code.result
}
