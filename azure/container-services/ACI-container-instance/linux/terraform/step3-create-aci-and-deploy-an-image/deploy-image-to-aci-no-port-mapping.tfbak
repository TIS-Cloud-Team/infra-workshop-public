## create linux aci
resource "azurerm_container_group" "my_container_group" {
  name                = local.aci_group_name
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  os_type             = "Linux"

  container {
    name   = local.aci_name
    image  = local.azure_image_name
    cpu    = "1.0"
    memory = "1.5"

    ports {
      port     = 8080
      protocol = "TCP"
    }

    environment_variables = {
      ASPNETCORE_HTTP_PORTS = "8080"
    }
  }

  tags = local.global_tags

  image_registry_credential {
    server   = local.azure_container_registry_login_server
    username = local.azure_container_registry_admin_username
    password = local.azure_container_registry_admin_password
  }

  ip_address_type = "Public"

}

## http://{public-ip}:8080
output "aci_public_ip" {
  value = azurerm_container_group.my_container_group.ip_address
}