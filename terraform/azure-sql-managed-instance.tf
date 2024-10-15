# TODO set the variables below either enter them in plain text after = sign, or change them in variables.tf
#  (var.xyz will take the default value from variables.tf if you don't change it)

# Create security group
resource "azurerm_network_security_group" "example" {
  name                = "nsg-${local.db_azure_sql_mi_name}"
  resource_group_name = local.rg_name
  location            = local.rg_location

  tags = local.global_tags
}

# Create a network security group rule to allow access on port 3342
resource "azurerm_network_security_rule" "allow_port_3342" {
  name                        = "Allow-sql-mi-port-3342"
  priority                    = 1500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3342"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = local.rg_name
  network_security_group_name = azurerm_network_security_group.example.name
}

# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = "vnet-${local.db_azure_sql_mi_name}"
  address_space       = ["10.0.0.0/24"]
  resource_group_name = local.rg_name
  location            = local.rg_location

  tags = local.global_tags
}

# Create a subnet
resource "azurerm_subnet" "example" {
  name                 = "${local.db_azure_sql_mi_name}-subnet"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/27"]


  delegation {
    name = "managedinstancedelegation"

    service_delegation {
      name = "Microsoft.Sql/managedInstances"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Associate subnet and the security group
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# Create a route table
resource "azurerm_route_table" "example" {
  name                          = "rt-${local.db_azure_sql_mi_name}"
  location                      = local.rg_location
  resource_group_name           = local.rg_name
  tags = local.global_tags
  ##disable_bgp_route_propagation = false
}

# Associate subnet and the route table
resource "azurerm_subnet_route_table_association" "example" {
  subnet_id      = azurerm_subnet.example.id
  route_table_id = azurerm_route_table.example.id

  depends_on = [azurerm_subnet_network_security_group_association.example]
}

# Create managed instance
## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_managed_instance
resource "azurerm_mssql_managed_instance" "main" {
  name                         = "${local.db_azure_sql_mi_name}"
  resource_group_name          = local.rg_name
  location                     = local.rg_location
  subnet_id                    = azurerm_subnet.example.id
  administrator_login          = local.db_user
  administrator_login_password = local.db_password
  license_type                 = local.db_license_type
  sku_name                     = local.db_sku_name
  vcores                       = local.db_vcores
  storage_size_in_gb           = local.db_storage_size_in_gb
  storage_account_type         = "LRS"  # Locally-redundant storage (LRS), Geo-redundant storage (GRS), Read-access geo-redundant storage (RA-GRS), Zone-redundant storage (ZRS), or Premium_LRS
  public_data_endpoint_enabled = true

  depends_on = [azurerm_resource_group.myresourcegroup, azurerm_subnet_route_table_association.example]

  tags = local.global_tags
}

## Output the managed instance server name
output "managed_instance_server_name" {
  value = azurerm_mssql_managed_instance.main.name
}

## Output the managed instance FQDN - please note this is not a public FQDN, internal FQDN
output "managed_instance_fqdn" {
  value = azurerm_mssql_managed_instance.main.fqdn
}

# Output the modified FQDN - to public FQDN
output "public_sql_managed_instance_fqdn" {
  value       = format("%s,3342", replace(azurerm_mssql_managed_instance.main.fqdn, local.db_azure_sql_mi_name, "${local.db_azure_sql_mi_name}.public"))
  description = "The modified FQDN for the SQL Managed Instance"
}

## Output the managed instance connection string
output "managed_instance_connection_string" {
  sensitive = true
  value = "Server=${azurerm_mssql_managed_instance.main.fqdn};User ID=${azurerm_mssql_managed_instance.main.administrator_login};Password=${random_password.password.result};"
}

# Output the public managed instance connection string
output "public_managed_instance_connection_string" {
  sensitive = true
  value     = "Server=${format("%s,3342", replace(azurerm_mssql_managed_instance.main.fqdn, local.db_azure_sql_mi_name, "${local.db_azure_sql_mi_name}.public"))};User ID=${azurerm_mssql_managed_instance.main.administrator_login};Password=${random_password.password.result};"
}


