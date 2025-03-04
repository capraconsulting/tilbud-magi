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

resource "azurerm_application_insights" "app_insights" {
  name                = "${var.project}-${var.environment}-appinsights"
  resource_group_name = azurerm_resource_group.function_rg.name
  location            = azurerm_resource_group.function_rg.location
  application_type    = "web"
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.project}-${var.environment}-log-analytics-workspace"
  location            = azurerm_resource_group.function_rg.location
  resource_group_name = azurerm_resource_group.function_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


resource "azurerm_linux_function_app" "function_app" {
  name                       = "${var.project}-${var.environment}-function-app"
  location                   = azurerm_resource_group.function_rg.location
  resource_group_name        = azurerm_resource_group.function_rg.name
  service_plan_id            = azurerm_service_plan.function_service_plan.id
  storage_account_name       = azurerm_storage_account.function_storage_account.name
  storage_account_access_key = azurerm_storage_account.function_storage_account.primary_access_key

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
    ]
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME              = "node"
    AzureWebJobsStorage                   = azurerm_storage_account.function_storage_account.primary_blob_connection_string
    WEBSITE_RUN_FROM_PACKAGE              = "1"
    APPINSIGHTS_INSTRUMENTATIONKEY        = azurerm_application_insights.app_insights.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.app_insights.connection_string
    OPENAI_API_KEY                        = var.openai_api_key
    FLOWCASE_API_KEY                      = var.flowcase_api_key
  }

  site_config {
    application_stack {
      node_version = "20"
    }
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_monitor_diagnostic_setting" "function_diagnostics" {
  name                       = "function-app-diagnostics"
  target_resource_id         = azurerm_linux_function_app.function_app.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

  enabled_log {
    category = "FunctionAppLogs"
  }
}