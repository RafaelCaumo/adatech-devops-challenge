resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "aks-letscode-dev"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aks-letscode"
  kubernetes_version  = 1.28

  api_server_access_profile {
    authorized_ip_ranges = ["0.0.0.0/0"]
  }

  http_application_routing_enabled = true

  default_node_pool {
    name                 = "default"
    vm_size              = "Standard_D2_v2"
    vnet_subnet_id       = azurerm_subnet.k8s_subnet.id
    auto_scaling_enabled = true
    min_count            = 1
    max_count            = 4
    os_disk_size_gb      = 30
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = null
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.k8s_log.id
  }

  lifecycle {
    ignore_changes = [default_node_pool[0].upgrade_settings]
  }
}

## K8S Network
resource "azurerm_subnet" "k8s_subnet" {
  name                 = "snet-k8s-letscode-dev"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = ["10.1.40.0/24"]

}

resource "azurerm_subnet_network_security_group_association" "k8s_association" {
  subnet_id                 = azurerm_subnet.k8s_subnet.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}
