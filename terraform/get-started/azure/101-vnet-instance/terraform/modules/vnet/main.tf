#Define the Azure Virtual Network.
resource "azurerm_virtual_network" "vnet" {
  name                = "em-network-${var.prefix}"
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  subnet {
    name           = "em-subnet-${var.prefix}"
    address_prefix = var.address_prefix
  }
}

#Define the Azure NAT Gateway.
resource "azurerm_nat_gateway" "nat" {
  name                = "em-natgateway-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

#Define association between Azure NAT Gateway and subnet. 
resource "azurerm_subnet_nat_gateway_association" "example" {
  subnet_id      = azurerm_virtual_network.vnet.subnet.*.id[0]
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

resource "azurerm_public_ip" "pubic_ip" {
  name                = "em-nat-gateway-publicIP-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.pubic_ip.id
}
