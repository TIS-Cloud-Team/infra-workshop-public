
## https://portal.azure.com/#browse/Microsoft.Sql%2Fazuresql

## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_server
resource "azurerm_mssql_server" "example" {
  name                         = local.db_azure_sql_name
  resource_group_name          = azurerm_resource_group.myresourcegroup.name
  location                     = azurerm_resource_group.myresourcegroup.location
  version                      = "12.0"
  administrator_login          = local.db_user
  administrator_login_password = local.db_password
  ##public_network_access_enabled = true
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

