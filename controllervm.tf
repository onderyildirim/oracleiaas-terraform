resource "azurerm_public_ip" "ora-controller-public-ip" {
  name                  = "${var.prefix}-ctl1-public-ip"
  location              = azurerm_resource_group.resourceGroup.location
  resource_group_name   = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ora-controller-nic" {
  name                = "${var.prefix}-controller-nic"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "${var.prefix}-controller-nic"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ora-controller-public-ip.id
  }

}

resource "azurerm_linux_virtual_machine" "controllervm" {
  name                  = "${var.prefix}-ctl1"
  location              = azurerm_resource_group.resourceGroup.location
  resource_group_name   = azurerm_resource_group.resourceGroup.name
  network_interface_ids = [azurerm_network_interface.ora-controller-nic.id]
  size               = var.oracleVmSize

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    name              = "${var.prefix}-controllervm-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username = var.oracleVMAdminUser
  admin_password = var.oracleVMAdminPassword
  disable_password_authentication = false

}


