resource "azurerm_resource_group" "resourceGroup" {
  name     = "${var.prefix}-rg"
  location = var.location
}
