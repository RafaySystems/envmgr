output "ssh_details" {
  value = "ssh -i <Path to Private Key File> ${var.vm_username}@${vsphere_virtual_machine.controlplane.default_ip_address}"
}
