resource "azurerm_resource_group" "rg" {
  count    = var.existing_resource_group_name == null && var.cloud_provider == "azure" ? 1 : 0
  name     = "${var.name}-rg"
  location = var.resource_group_location
}

# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  count    = var.existing_resource_group_name == null && var.cloud_provider == "azure" ? 1 : 0
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg[0].location
  resource_group_name = azurerm_resource_group.rg[0].name
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  count    = var.existing_resource_group_name == null && var.cloud_provider == "azure" ? 1 : 0
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg[0].name
  virtual_network_name = azurerm_virtual_network.my_terraform_network[0].name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  count = var.cloud_provider == "azure" ? var.num_instances : 0
  name                = "${var.name}-${count.index}-ip"
  location            = azurerm_resource_group.rg[0].location
  resource_group_name = azurerm_resource_group.rg[0].name
  allocation_method   = "Dynamic"
}



resource "azurerm_network_security_group" "my_terraform_nsg" {
  count = var.cloud_provider == "azure" ? 1 : 0
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.rg[0].location
  resource_group_name = azurerm_resource_group.rg[0].name
}

resource "azurerm_network_security_rule" "test" {
  count = var.cloud_provider == "azure" ? "${length(var.security_group_ports)}" : 0
  name                       = "sg-rule-${count.index}"
  direction                  = "Inbound"
  access                     = "Allow"
  priority                   = (100 * (tonumber("${count.index}") + 1))
  source_address_prefix      = "*"
  source_port_range          = "*"
  destination_address_prefix = "*"
  destination_port_range     = "${element(var.security_group_ports, count.index)}"
  protocol                   = "Tcp"
  resource_group_name         = azurerm_resource_group.rg[0].name
  network_security_group_name = azurerm_network_security_group.my_terraform_nsg[0].name
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  count = var.cloud_provider == "azure" ? var.num_instances : 0
  name                = "${var.name}-${count.index}-nic"
  location            = azurerm_resource_group.rg[0].location
  resource_group_name = azurerm_resource_group.rg[0].name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip[count.index].id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  count = var.cloud_provider == "azure" ? var.num_instances : 0
  network_interface_id      = azurerm_network_interface.my_terraform_nic[count.index].id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg[0].id
  depends_on = [azurerm_network_security_rule.test]
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  count = var.cloud_provider == "azure" ? var.num_instances : 0
  name                  = "${var.name}-${count.index}"
  location              = azurerm_resource_group.rg[0].location
  resource_group_name   = azurerm_resource_group.rg[0].name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic[count.index].id]
  size                  = var.instance_config[var.instance_size]["machine_type"]

  os_disk {
    name                 = "${var.name}-${count.index}-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb 	 = var.instance_config[var.instance_size]["node_disk_size"]
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "${var.name}-${count.index}"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = var.ssh_public_key
  }
  depends_on = [azurerm_network_security_rule.test]
}