terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.18.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "fc2cabdd-0bf9-4cb9-8564-be25c6b2dead"
  features {}
}