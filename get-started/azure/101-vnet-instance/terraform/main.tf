resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_group_name}-${random_string.resource_code.result}"
  location = var.location
}

module "azure-vnet" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  prefix              = random_string.resource_code.result
}

module "azure-vm" {
  source              = "./modules/instance"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  subnet_id           = module.azure-vnet.subnet_id
  size                = var.size
  prefix              = random_string.resource_code.result
}
