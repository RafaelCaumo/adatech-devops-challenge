resource "helm_release" "backend" {
  name             = "backend"
  chart            = "../backend/app/charts/api"
  force_update     = true
  namespace        = "backend"
  create_namespace = true

  set {
    name  = "image.version"
    value = "1.2.0"
  }

  set {
    name  = "environment"
    value = "development"
  }

  set {
    name  = "ingress.dnsZone"
    value = azurerm_kubernetes_cluster.k8s.http_application_routing_zone_name
  }

  set {
    name  = "envVariables.SPRING_DATASOURCE_URL"
    value = "jdbc:mysql://${azurerm_mysql_flexible_server.mysql_server.fqdn}:3306/${azurerm_mysql_flexible_database.mysql_database.name}"
  }

  set {
    name  = "envVariables.SPRING_DATASOURCE_USERNAME"
    value = azurerm_mysql_flexible_server.mysql_server.administrator_login
  }

  set {
    name  = "envVariables.SPRING_DATASOURCE_PASSWORD"
    value = azurerm_mysql_flexible_server.mysql_server.administrator_password
  }

  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]
}

resource "helm_release" "frontend" {
  name             = "frontend"
  chart            = "../frontend/app/charts/frontend"
  force_update     = true
  namespace        = "frontend"
  create_namespace = true

  set {
    name  = "image.version"
    value = "1.2.0"
  }

  set {
    name  = "environment"
    value = "development"
  }

  set {
    name  = "ingress.dnsZone"
    value = azurerm_kubernetes_cluster.k8s.http_application_routing_zone_name
  }

  set {
    name  = "envVariables.APP_API_BASE_URL"
    value = "http://api.ada.development.${azurerm_kubernetes_cluster.k8s.http_application_routing_zone_name}"
  }

  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]
}