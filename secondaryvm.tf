# create a virtual machine with oracle image



resource "azurerm_network_interface" "ora-secondary-nic" {
  name                = "${var.prefix}-secondary-nic"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "${var.prefix}-secondary-nic"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }

}


resource "azurerm_linux_virtual_machine" "secondaryvm" {
  name                  = "${var.prefix}-vm1"
  location              = azurerm_resource_group.resourceGroup.location
  resource_group_name   = azurerm_resource_group.resourceGroup.name
  network_interface_ids = [azurerm_network_interface.ora-secondary-nic.id]
  size               = var.oracleVmSize
  availability_set_id = azurerm_availability_set.avset.id

  # source_image_reference {
  #   publisher = "Oracle"
  #   offer     = "oracle-database-19-3"
  #   sku       = "oracle-database-19-0904"
  #   version   = "19.3.1"
  # }
  source_image_reference {
    publisher = "Oracle"
    offer     = "oracle-database"
    sku       = "oracle_db_21"
    version   = "21.0.0"
  }

  os_disk {
    name              = "${var.prefix}-secondaryvm-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username = var.oracleVMAdminUser
  admin_password = var.oracleVMAdminPassword
  disable_password_authentication = false

  #custom_data = data.cloudinit_config.ora-vm-cloudinit-config.rendered
  #custom_data  = filebase64("./configurevm.sh")

  # lifecycle {
  # replace_triggered_by = [
  #   data.local_file.ora-vm-script
  #   ]
  # }

  # admin_ssh_key {
  #   username   = var.oracleVMAdminUser
  #   public_key = file(var.sshKeyFile)
  # }

}

