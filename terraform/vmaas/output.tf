output "vm_details" {
  value = {
      hostname           = vsphere_virtual_machine.controlplane.name
      operating_system   = var.vm_os
      private_ip    = vsphere_virtual_machine.controlplane.default_ip_address
      ssh = {
        ip_address       = vsphere_virtual_machine.controlplane.default_ip_address
        port             = "22" # Default SSH Port
        private_key_path = "private-key" # Adjust path as needed
        username         = var.vm_username
      }
  }
}
