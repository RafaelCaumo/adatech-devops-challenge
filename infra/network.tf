resource "azurerm_virtual_network" "main" {
  name                = "vnet-letscode-prod-westeurope"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.1.0.0/16"]


}

# Subnets Públicas
/* resource "azurerm_subnet" "public_1" {
  name                 = "snet-public-letscode-prod-1"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
} */

/* resource "azurerm_subnet" "public_2" {
  name                 = "snet-public-letscode-prod-2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
} */

/* resource "azurerm_subnet" "public_3" {
  name                 = "snet-public-letscode-prod-3"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.3.0/24"]
} */

# Subnets Privadas
/* resource "azurerm_subnet" "private_1" {
  name                 = "snet-private-letscode-prod-1"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.4.0/24"]
} */

/* resource "azurerm_subnet" "private_2" {
  name                 = "snet-private-letscode-prod-2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.5.0/24"]
} */

/* resource "azurerm_subnet" "private_3" {
  name                 = "snet-private-letscode-prod-3"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.6.0/24"]
} */