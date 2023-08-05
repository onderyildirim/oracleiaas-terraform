
resource "azurerm_virtual_network" "virtualNetwork" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.virtualNetwork.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_network_security_group" "vnetLockdownNsg" {
  name                = "${var.prefix}-vnet-nsg"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  security_rule {
    name                       = "AllowVNet"
    priority                   = 3400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "DenyAllInBound"
    priority                   = 3500
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# Create a Network Interface Security Group association
# resource "azurerm_network_interface_security_group_association" "vnetLockdownNsgAssociation" {
#   network_interface_id      = azurerm_network_interface.ora-primary-nic.id
#   network_security_group_id = azurerm_network_security_group.vnetLockdownNsg.id
# }

resource "azurerm_subnet_network_security_group_association" "vnetLockdownNsgAssociation" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.vnetLockdownNsg.id
}

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

# Create a Network Interface Security Group association
resource "azurerm_network_interface_security_group_association" "vnetLockdownNsg" {
  network_interface_id      = azurerm_network_interface.ora-secondary-nic.id
  network_security_group_id = azurerm_network_security_group.vnetLockdownNsg.id
}


resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.virtualNetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "BastionIP" {
  name                = "${var.prefix}-BastionIP"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_bastion_host" "Bastion" {
  name                = "${var.prefix}-bastion"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.BastionIP.id
  }
}