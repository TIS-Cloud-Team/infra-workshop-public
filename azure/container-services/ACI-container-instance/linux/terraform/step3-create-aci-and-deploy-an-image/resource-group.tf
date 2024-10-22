
## Create a resource group
## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group

##resource "azurerm_resource_group" "myresourcegroup" {
##  #count    = data.azurerm_resource_group.existing.id != null ? 0 : 1
##  name     = local.rg_name
##  location = local.rg_location

##  tags = local.global_tags
##}

## Use an existing resource group
data "azurerm_resource_group" "existing" {
  name = local.azure_existing_resource_group_name 
}

output "resource_group_id" {
  value = data.azurerm_resource_group.existing.id
}