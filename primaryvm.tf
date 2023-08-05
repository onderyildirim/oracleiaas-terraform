# create a virtual machine with oracle image



resource "azurerm_network_interface" "ora-primary-nic" {
  name                = "${var.prefix}-primary-nic"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "${var.prefix}-primary-nic"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }

}



resource "azurerm_linux_virtual_machine" "primaryvm" {
  name                  = "${var.prefix}-vm1"
  location              = azurerm_resource_group.resourceGroup.location
  resource_group_name   = azurerm_resource_group.resourceGroup.name
  network_interface_ids = [azurerm_network_interface.ora-primary-nic.id]
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
    name              = "${var.prefix}-primaryvm-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username = var.oracleVMAdminUser
  admin_password = var.oracleVMAdminPassword
  disable_password_authentication = false

  custom_data = data.cloudinit_config.ora-vm-cloudinit-config.rendered

  # lifecycle {
  # replace_triggered_by = [
  #   data.local_file.ora-vm-script
  #   ]
  # }

  # admin_ssh_key {
  #   username   = var.oracleVMAdminUser
  #   public_key = file(var.sshKeyFile)
  # }

#custom_data  = filebase64("./configurevm.sh")
}

# resource "azurerm_virtual_machine_extension" "init-ora-vm" {
#   name                 = "${var.prefix}-primaryvm-ext"
#   virtual_machine_id   = azurerm_linux_virtual_machine.primaryvm.id
#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.0"

#   # settings = <<SETTINGS
#   # {
#   #   "commandToExecute": "hostname && uptime"
#   # }
#   # SETTINGS

#   # protected_settings = <<PROT
#   # {
#   #     "script": "${base64encode(file(var.scfile))}"
#   # }
#   # PROT


#   connection {
#     type     = "ssh"
#     agent    =false
#     user     = "${var.oracleVMAdminUser}"
#     password = "${var.oracleVMAdminPassword}"
#     host     = "${azurerm_network_interface.ora-primary-nic.private_ip_address}"
#     bastion_host = "${azurerm_public_ip.BastionIP.ip_address}"
#   }
#   provisioner "file" {
#     source      = var.configureVmScriptFile
#     destination = "/tmp/${var.configureVmScriptFile}"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/${var.configureVmScriptFile}",
#       "/tmp/${var.configureVmScriptFile} ${local.oraMntDir} ${azurerm_netapp_volume.anfVolume.mount_ip_addresses[0]} ${azurerm_netapp_volume.anfVolume.name}"
#     ]
#   }

# }

# resource "azurerm_virtual_machine" "primaryvm" {
#   name                  = "${var.prefix}-vm1"
#   location              = azurerm_resource_group.resourceGroup.location
#   resource_group_name   = azurerm_resource_group.resourceGroup.name
#   network_interface_ids = [azurerm_network_interface.ora-primary-nic.id]
#   vm_size               = var.oracleVmSize
#   availability_set_id = azurerm_availability_set.avset.id

#   storage_image_reference {
#     publisher = "Oracle"
#     offer     = "oracle-database-19-3"
#     sku       = "oracle-database-19-0904"
#     version   = "19.3.1"
#   }

#   storage_os_disk {
#     name              = "${var.prefix}-primaryvm-osdisk"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }

#   os_profile {
#     computer_name  = "${var.prefix}-vm1"
#     admin_username = var.oracleVMAdminUser
#     admin_password = var.oracleVMAdminPassword
#   }

#   os_profile_linux_config {
#     disable_password_authentication = false
#   }

# }


# resource "azurerm_linux_virtual_machine" "tfexample" {
#   name                            = "my-terraform-vm"
#   location                        = azurerm_resource_group.tfexample.location
#   resource_group_name             = azurerm_resource_group.tfexample.name
#   network_interface_ids           = [azurerm_network_interface.tfexample.id]
#   size                            = "Standard_DS1_v2"
#   computer_name                   = "myvm"
#   admin_username                  = "azureuser"
#   admin_password                  = "Password1234!"
#   disable_password_authentication = false

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   os_disk {
#     name                 = "my-terraform-os-disk"
#     storage_account_type = "Standard_LRS"
#     caching              = "ReadWrite"
#   }

#   tags = {
#     environment = "my-terraform-env"
#   }
# }

# # Configurate to run automated tasks in the VM start-up
# resource "azurerm_virtual_machine_extension" "tfexample" {
#   name                 = "hostname"
#   virtual_machine_id   = azurerm_linux_virtual_machine.tfexample.id
#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.1"

#   settings = <<SETTINGS
#     {
#       "commandToExecute": "echo 'Hello, World' > index.html ; nohup busybox httpd -f -p ${var.server_port} &"
#     }
#   SETTINGS

#   tags = {
#     environment = "my-terraform-env"
#   }
# }
