terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-prod-westeurope"
    storage_account_name = "sttfstateprod24383"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
