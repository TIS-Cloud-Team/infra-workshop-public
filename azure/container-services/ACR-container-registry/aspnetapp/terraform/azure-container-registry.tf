##  
resource "azurerm_container_registry" "acr" {
  name                = local.azure_container_name
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location            = azurerm_resource_group.myresourcegroup.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = local.global_tags
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
  value = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "acr_name" {
  value = local.azure_container_name
}

## terraform output --json