# Outputs for the vcn module

output "vcn_id" {
  value = module.vcn.vcn_id
}

output "kubeconfig" {
  value     = module.oke.kubeconfig
  sensitive = true
}
