resource "azurerm_mysql_flexible_server" "mysql_server" {
  name                  = "mysql-letscode-prod"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  version               = "8.0.21"
  sku_name              = "B_Standard_B2s"
  backup_retention_days = 7
  zone                  = "1"


  administrator_login    = "letscode_admin"
  administrator_password = "SecurePass123!"

  delegated_subnet_id = azurerm_subnet.mysql_subnet.id
  private_dns_zone_id = azurerm_private_dns_zone.mysql_dns.id



  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.mysql_vnet_link
  ]
}

resource "azurerm_mysql_flexible_database" "mysql_database" {
  name                = "letscode_database"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.mysql_server.name
  charset             = "utf8mb3"
  collation           = "utf8mb3_unicode_ci"
}

## DB Network
resource "azurerm_subnet" "mysql_subnet" {
  name                 = "snet-mysql-letscode-prod"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = ["10.1.30.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "dlg-Microsoft.DBforMySQL-flexibleServers"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "mysql_association" {
  subnet_id                 = azurerm_subnet.mysql_subnet.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}

resource "azurerm_private_dns_zone" "mysql_dns" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql_vnet_link" {
  name                  = "mysql-vnet-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.mysql_dns.name
  virtual_network_id    = azurerm_virtual_network.main.id
}