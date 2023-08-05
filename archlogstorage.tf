resource "azurerm_storage_account" "archiveLogStorageAccount" {
  name                     = "${var.prefix}archivelogstorage"
  resource_group_name      = azurerm_resource_group.resourceGroup.name
  location                 = azurerm_resource_group.resourceGroup.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

}

resource "azurerm_storage_account_network_rules" "archiveLogStorageAccountNetworkRules" {
  storage_account_id = azurerm_storage_account.archiveLogStorageAccount.id

  default_action             = "Deny"
  ip_rules                   = [chomp(data.http.myIpAddress.response_body)] #add an ip rule for your IP address, this will prevent access errors when you run terraform apply after the initial creation
  virtual_network_subnet_ids = [azurerm_subnet.subnet1.id]
  bypass                     = ["Metrics"]
}


resource "azurerm_storage_share" "archiveLogShare" {
  name                 = "archivelogshare"
  storage_account_name = azurerm_storage_account.archiveLogStorageAccount.name
  quota                = 4096

}

resource "azurerm_recovery_services_vault" "oracleBackupVault" {
  name                = "${var.prefix}-oracleBackupVault"
  resource_group_name      = azurerm_resource_group.resourceGroup.name
  location                 = azurerm_resource_group.resourceGroup.location
  sku                 = "Standard"
}

resource "azurerm_backup_policy_vm" "oracleBackupVaultPolicy" {
  name                = "${var.prefix}-oracleBackupVaultPolicy"
  resource_group_name      = azurerm_resource_group.resourceGroup.name
  recovery_vault_name = azurerm_recovery_services_vault.oracleBackupVault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }
}