
output "vcn_id" {
  value = module.vcn.vcn_id
}

output "oke_security_group_id" {
  value = oci_core_network_security_group.oke_security_group.id
}

output "vcn_public_subnet_id" {
  value = oci_core_subnet.vcn-public-subnet.id
}

output "vcn_private_subnet_id" {
  value = oci_core_subnet.vcn-private-subnet.id
}
