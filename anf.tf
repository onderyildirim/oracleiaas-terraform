resource "azurerm_subnet" "anfSubnet" {
  name                 = "ANFSubnet"
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.virtualNetwork.name
  delegation {
    name = "Microsoft.Netapp/volumes"
    service_delegation {
      name    = "Microsoft.Netapp/volumes"
      actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/read", "Microsoft.Network/virtualNetworks/subnets/action", "Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}


resource "azurerm_netapp_account" "anfAccount" {
  name                = "${var.prefix}-anfAccount"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
}

resource "azurerm_netapp_pool" "anfPool" {
  name                = "${var.prefix}-anfPool"
  account_name        = azurerm_netapp_account.anfAccount.name
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  service_level       = "Premium"
  size_in_tb          = 4
}

resource "azurerm_netapp_volume" "anfVolume" {
  lifecycle {
    prevent_destroy = false
  }

  name                       = "${var.prefix}-anfVolume"
  location                   = azurerm_resource_group.resourceGroup.location
  zone                       = "1"
  resource_group_name        = azurerm_resource_group.resourceGroup.name
  account_name               = azurerm_netapp_account.anfAccount.name
  pool_name                  = azurerm_netapp_pool.anfPool.name
  volume_path                = "${var.prefix}-anfVolume"
  service_level              = "Premium"
  subnet_id                  = azurerm_subnet.anfSubnet.id
  protocols                  = ["NFSv3"]
#   allowed_clients            = [azurerm_network_interface.ora-primary-nic.private_ip_address]
#   rule_index                 = 1
  security_style             = "Unix"
  storage_quota_in_gb        = 1024
#   snapshot_directory_visible = false
  export_policy_rule {
    rule_index        = 1
    allowed_clients   = [azurerm_network_interface.ora-primary-nic.private_ip_address]
    protocols_enabled = ["NFSv3"]
    unix_read_only    = false
    unix_read_write   = true
    root_access_enabled = true
  }
  }