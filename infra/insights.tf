resource "azurerm_log_analytics_workspace" "k8s_log" {
  name                = "log-letscode-dev"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "PerGB2018"


}

resource "azurerm_log_analytics_solution" "containers_insights" {
  solution_name         = "ContainerInsights"
  workspace_resource_id = azurerm_log_analytics_workspace.k8s_log.id
  workspace_name        = azurerm_log_analytics_workspace.k8s_log.name
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}