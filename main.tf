# main.tf
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.31.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "61edce70-81b3-4cbd-9659-6a5132989c1d"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_container_app_environment" "aca_env" {
  name                       = var.container_app_env_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  
}

resource "azurerm_user_assigned_identity" "aca_identity" {
  name                = "acaIdentity"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "acr_push" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.aca_identity.principal_id
}