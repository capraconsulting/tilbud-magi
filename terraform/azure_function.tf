variable "resource_group_name" {
  description = "Name of the resource group where the Function App will be deployed"
  default     = "my-resource-group"
}

variable "location" {
  description = "Azure region for the resources"
  default     = "North Europe"
}


resource "azurerm_resource_group" "tilbud-magi-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = "functionappstorageacct"
  resource_group_name      = azurerm_resource_group.tilbud-magi-rg.name
  location                 = azurerm_resource_group.tilbud-magi-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "function_service_plan" {
  name                = "example-service-plan"
  location            = azurerm_resource_group.tilbud-magi-rg.location
  resource_group_name = azurerm_resource_group.tilbud-magi-rg.name

  os_type  = "Linux"
  sku_name = "Y1"
}

resource "azurerm_linux_function_app" "function_app" {
  name                       = "example-function-app"
  location                   = azurerm_resource_group.tilbud-magi-rg.location
  resource_group_name        = azurerm_resource_group.tilbud-magi-rg.name
  service_plan_id        = azurerm_service_plan.function_service_plan.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "node"
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }

  site_config {}
}