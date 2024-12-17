resource "azurerm_monitor_workspace" "amw" {
  name                = "amw-letscode-dev"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

resource "azurerm_monitor_data_collection_endpoint" "dce" {
  name                = substr("MSProm-${azurerm_resource_group.main.location}-${azurerm_kubernetes_cluster.k8s.name}", 0, min(44, length("MSProm-${azurerm_resource_group.main.location}-${azurerm_kubernetes_cluster.k8s.name}")))
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  kind                = "Linux"
}

resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                        = substr("MSProm-${azurerm_resource_group.main.location}-${azurerm_kubernetes_cluster.k8s.name}", 0, min(64, length("MSProm-${azurerm_resource_group.main.location}-${azurerm_kubernetes_cluster.k8s.name}")))
  resource_group_name         = azurerm_resource_group.main.name
  location                    = azurerm_resource_group.main.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce.id
  kind                        = "Linux"

  destinations {
    monitor_account {
      monitor_account_id = azurerm_monitor_workspace.amw.id
      name               = "MonitoringAccount1"
    }
  }

  data_flow {
    streams      = ["Microsoft-PrometheusMetrics"]
    destinations = ["MonitoringAccount1"]
  }

  data_sources {
    prometheus_forwarder {
      streams = ["Microsoft-PrometheusMetrics"]
      name    = "PrometheusDataSource"
    }
  }

  description = "DCR for Azure Monitor Metrics Profile (Managed Prometheus)"
  depends_on = [
    azurerm_monitor_data_collection_endpoint.dce
  ]
}

resource "azurerm_monitor_data_collection_rule_association" "dcra" {
  name                    = "MSProm-${azurerm_resource_group.main.location}-${azurerm_kubernetes_cluster.k8s.name}"
  target_resource_id      = azurerm_kubernetes_cluster.k8s.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr.id
  description             = "Association of data collection rule. Deleting this association will break the data collection for this AKS Cluster."
  depends_on = [
    azurerm_monitor_data_collection_rule.dcr
  ]
}

resource "azurerm_dashboard_grafana" "grafana" {
  name                  = "amg-letscode-dev"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  grafana_major_version = 10

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.amw.id
  }
}

resource "azurerm_role_assignment" "datareaderrole" {
  scope                = azurerm_monitor_workspace.amw.id
  role_definition_name = "Monitoring Data Reader"
  principal_id         = azurerm_dashboard_grafana.grafana.identity.0.principal_id
}

resource "azurerm_role_assignment" "grafanaadminrole" {
  scope                = azurerm_dashboard_grafana.grafana.id
  role_definition_name = "Grafana Admin"
  principal_id         = data.azurerm_client_config.main.object_id
}
