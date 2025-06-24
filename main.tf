# main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
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
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_container_app_environment" "aca_env" {
  name                = var.container_app_env_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

}

resource "azurerm_user_assigned_identity" "aca_identity" {
  name                = "acaIdentity"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "acr_push" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.aca_identity.principal_id
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aca_identity.principal_id
}
resource "azurerm_service_plan" "linux_plan" {
  name                = "linux_plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}
resource "azurerm_linux_web_app" "backend" {
  name                = "backendmernjrn"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.linux_plan.location
  service_plan_id     = azurerm_service_plan.linux_plan.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aca_identity.id]
  }

  site_config {
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = azurerm_user_assigned_identity.aca_identity.client_id   
  }
}

resource "azurerm_linux_web_app" "frontend" {
  name                = "frontendmernjrn"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.linux_plan.location
  service_plan_id     = azurerm_service_plan.linux_plan.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aca_identity.id]
  }

  site_config {
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = azurerm_user_assigned_identity.aca_identity.client_id   
  }
}

