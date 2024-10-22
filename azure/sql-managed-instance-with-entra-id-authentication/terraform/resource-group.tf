
## Create a resource group
## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "myresourcegroup" {
  #count    = data.azurerm_resource_group.existing.id != null ? 0 : 1
  name     = local.rg_name
  location = local.rg_location

  tags = local.global_tags
}

output "resource_group_id" {
  value = azurerm_resource_group.myresourcegroup.id ##var.myRG #data.azurerm_resource_group.existing.id
}