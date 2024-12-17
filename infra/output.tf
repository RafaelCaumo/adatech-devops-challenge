output "frontend_address" {
  value = "http://ada.development.${azurerm_kubernetes_cluster.k8s.http_application_routing_zone_name}"
}
output "grafana_address" {
  value = azurerm_dashboard_grafana.grafana.endpoint
}