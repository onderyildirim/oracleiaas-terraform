locals {
    updateDomainCount=6
    faultDomainCount=2
    }
    
    
resource "azurerm_availability_set" "avset" {
  name                = "${var.prefix}-avset"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  platform_fault_domain_count = local.faultDomainCount
  platform_update_domain_count = local.updateDomainCount 
}
