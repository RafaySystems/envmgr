output "controlplane_node_details" {
  value = {
    for i in vsphere_virtual_machine.controlplane : i.name => {
      arch               = "amd64"
      hostname           = i.name
      operating_system   = var.vm_os
      private_ip    = i.default_ip_address
      kubelet_extra_args = {
        max-pods                     = "300"
        cpu-manager-reconcile-period = "30s"
      }
      roles              = ["ControlPlane", "Worker"]
      ssh = {
        ip_address       = i.default_ip_address
        port             = "22" # Default SSH Port
        private_key_path = "private-key" # Adjust path as needed
        username         = var.vm_username
      }
    }
  }
}
