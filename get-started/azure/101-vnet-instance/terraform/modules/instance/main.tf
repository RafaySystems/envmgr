resource "random_password" "password" {
  length  = 12
  special = true
}

resource "azurerm_network_interface" "nic" {
  name                = "em-nic-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "internal"
    #subnet_id                     = azurerm_virtual_network.vnet.subnet.*.id[0]
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

#Define Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "em-machine-${var.prefix}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = "adminuser"
  admin_password                  = random_password.password.result
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
