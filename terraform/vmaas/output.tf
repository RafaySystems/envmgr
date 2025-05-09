output "vm_details" {
  value = {
      arch               = "amd64"
      hostname           = i.name
      operating_system   = var.vm_os
      private_ip    = i.default_ip_address
      ssh = {
        ip_address       = i.default_ip_address
        port             = "22" # Default SSH Port
        private_key_path = "private-key" # Adjust path as needed
        username         = var.vm_username
      }
  }
}
