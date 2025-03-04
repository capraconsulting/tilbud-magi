output "function_app_name" {
  value       = azurerm_linux_function_app.function_app.name
  description = "Deployed function app name"
}

output "function_app_default_hostname" {
  value       = azurerm_linux_function_app.function_app.default_hostname
  description = "Deployed function app hostname"
}

output "storage_account_name" {
  value = azurerm_storage_account.function_storage_account.name
  description = "Name of deployed storage account"
}