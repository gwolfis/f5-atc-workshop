
# Create an Azure vnet

resource "azurerm_virtual_network" "vnet" {
  name                = "student${local.setup.azure.student_number}-vnet"
  address_space       = [local.setup.network.cidr]
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Create Management subnet
resource "azurerm_subnet" "management" {
  name                 = "managememt"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefix       = local.setup.network["subnet-management"]
}

# Create External subnet
resource "azurerm_subnet" "external" {
  name                 = "external"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefix       = local.setup.network["subnet-external"]
}

# Create Internal Subnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefix       = local.setup.network["subnet-internal"]
}