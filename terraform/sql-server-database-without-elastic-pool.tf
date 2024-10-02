## Create a SQL Server and a SQL Database without Elastic Pool
## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server
resource "azurerm_mssql_database" "db-dev" {
  name                = local.db_name
  server_id           = azurerm_mssql_server.example.id
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  license_type        = "LicenseIncluded"
  read_scale          = false
  sku_name            = "S0"  # S0 corresponds to 10 DTUs
  zone_redundant      = false
  auto_pause_delay_in_minutes = 0

  tags = local.global_tags
}

output "sql_database_server_name" {
  value = azurerm_mssql_server.example.name
}

output "sql_database_connection_string" {
  sensitive = true
  value = "Server=${azurerm_mssql_server.example.fully_qualified_domain_name};Database=${azurerm_mssql_database.db-dev.name};User Id=${azurerm_mssql_server.example.administrator_login};Password=${azurerm_mssql_server.example.administrator_login_password};"
}