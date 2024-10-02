
## https://portal.azure.com/#browse/Microsoft.Sql%2Fazuresql

## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_server
resource "azurerm_mssql_server" "example" {
  name                         = local.db_azure_sql_name
  resource_group_name          = azurerm_resource_group.myresourcegroup.name
  location                     = azurerm_resource_group.myresourcegroup.location
  version                      = "12.0"
  administrator_login          = local.db_user
  administrator_login_password = local.db_password
  minimum_tls_version          = "1.2"
  ##public_network_access_enabled = true ## by default it is true

  ## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server#azuread_administrator
  azuread_administrator {
    login_username = data.azuread_user.current.user_principal_name ##data.azurerm_client_config.current.client_id ##local.entra_id_admin
    object_id      = data.azurerm_client_config.current.object_id ##data.azuread_user.entra_id_admin.object_id
  }

  tags = local.global_tags
}

## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule
resource "azurerm_mssql_firewall_rule" "example-1" {
  name                = "access-rule-open-to-public-all"
  server_id         = azurerm_mssql_server.example.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

##  
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  server_id         = azurerm_mssql_server.example.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

## Data source to get the Azure AD user object ID
## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/ad_user
#data "azuread_user" "entra_id_admin" {
#  user_principal_name = local.entra_id_admin
#}

## Data source to get the current Azure client configuration
data "azurerm_client_config" "current" {}

## Data source to get the Azure AD user object ID and user principal name
## https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user
data "azuread_user" "current" {
  object_id = data.azurerm_client_config.current.object_id
}

## Output the user principal name and object ID
output "user_principal_name" {
  value = data.azuread_user.current.user_principal_name
}

output "object_id" {
  value = data.azuread_user.current.object_id
}