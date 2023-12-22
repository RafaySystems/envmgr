resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

module "vcn" {
  source         = "./modules/vcn"
  vcn_name       = var.vcn_name
  compartment_id = var.compartment_id
  region         = var.region
  vcn_cidr       = var.vcn_cidr
}

module "oke" {
  source              = "./modules/oke"
  compartment_id      = var.compartment_id
  cluster_name        = var.cluster_name
  k8s_version         = var.k8s_version
  vcn_id              = module.vcn.vcn_id
  nsg_ids             = module.vcn.oke_security_group_id
  subnet_id           = module.vcn.vcn_public_subnet_id
  availability_domain = var.availability_domain
  private_subnet_id   = module.vcn.vcn_private_subnet_id
  size                = var.size
  image               = var.image
}
