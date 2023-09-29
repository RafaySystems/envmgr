output "instance" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "instance_ip" {
  value = azurerm_linux_virtual_machine.vm.private_ip_address
}
