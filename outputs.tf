output "resource_group_name" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  description = "Login server of the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}
output "identity_client_id" {
  value = azurerm_user_assigned_identity.aca_identity.client_id
}

output "identity_principal_id" {
  value = azurerm_user_assigned_identity.aca_identity.principal_id
}
