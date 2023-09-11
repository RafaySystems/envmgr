resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "k8ssubnet" {
  name                 = "${azurerm_virtual_network.vnet.name}-${var.k8s_subnet_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.k8s_subnet_address
}

resource "azurerm_network_security_group" "k8s_subnet_nsg" {
  name                = "${azurerm_subnet.k8ssubnet.name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "k8s_subnet_nsg_associate" {
  depends_on = [ azurerm_network_security_rule.k8s_nsg_rule_inbound]
  subnet_id                 = azurerm_subnet.k8ssubnet.id
  network_security_group_id = azurerm_network_security_group.k8s_subnet_nsg.id
}


locals {
  k8s_inbound_ports_map = {
    "100" : "80",
    "110" : "443",
    "120" : "22"
  }
}
resource "azurerm_network_security_rule" "k8s_nsg_rule_inbound" {
  for_each = local.k8s_inbound_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.k8s_subnet_nsg.name
}


resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resource_group_location

  name = var.cluster_name
}