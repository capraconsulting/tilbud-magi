resource "azurerm_resource_group" "function_rg" {
  name     = "${var.project}-${var.environment}-rg"
  location = var.location

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_account" "function_storage_account" {
  name                     = "${var.project}${var.environment}account"
  resource_group_name      = azurerm_resource_group.function_rg.name
  location                 = azurerm_resource_group.function_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_service_plan" "function_service_plan" {
  name                = "${var.project}-${var.environment}-service-plan"
  location            = azurerm_resource_group.function_rg.location
  resource_group_name = azurerm_resource_group.function_rg.name

  os_type  = "Linux"
  sku_name = "Y1"

  tags = {
    environment = var.environment
  }
}

# resource "azurerm_application_insights" "application_insights" {
#   name                = "${var.project}-${var.environment}-application-insights"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.function_rg.name
#   application_type    = "Node.JS"
# }

resource "azurerm_linux_function_app" "function_app" {
  name                       = "${var.project}-${var.environment}-function-app"
  location                   = azurerm_resource_group.function_rg.location
  resource_group_name        = azurerm_resource_group.function_rg.name
  service_plan_id            = azurerm_service_plan.function_service_plan.id
  storage_account_name       = azurerm_storage_account.function_storage_account.name
  storage_account_access_key = azurerm_storage_account.function_storage_account.primary_access_key

#   app_settings = {
#     "WEBSITE_RUN_FROM_PACKAGE"       = "",
#     "FUNCTIONS_WORKER_RUNTIME"       = "node",
#     "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.application_insights.instrumentation_key,
#   }
#
  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
    ]
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME    = "node"
    AzureWebJobsStorage         = azurerm_storage_account.function_storage_account.primary_blob_connection_string
    WEBSITE_RUN_FROM_PACKAGE    = "1"
  }


  site_config {}

  tags = {
    environment = var.environment
  }
}

