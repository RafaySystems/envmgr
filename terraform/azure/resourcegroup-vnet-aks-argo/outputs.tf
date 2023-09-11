output "virtual_network_name" {
  description = "Virtual Network Name"
  value = azurerm_virtual_network.vnet.name
}

output "virtual_network_id" {
  description = "Virtual Network ID"
  value = azurerm_virtual_network.vnet.id
}

output "k8s_subnet_name" {
  description = "K8s Subnet Name"
  value = azurerm_subnet.k8ssubnet.name
}

output "k8s_subnet_id" {
  description = "K8s Subnet ID"
  value = azurerm_subnet.k8ssubnet.id
}


output "k8s_subnet_nsg_name" {
  description = "K8s Subnet NSG Name"
  value = azurerm_network_security_group.k8s_subnet_nsg.name
}

output "web_subnet_nsg_id" {
  description = "K8s Subnet NSG ID"
  value = azurerm_network_security_group.k8s_subnet_nsg.id
}