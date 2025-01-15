## Create a storage account
## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "example" {
  name                     = local.storage_account_name ## storacct4... azure storage account name contains only lowercase letters and numbers - must startwith character, storageaacct 24 character limits
  resource_group_name      = azurerm_resource_group.myresourcegroup.name
  location                 = azurerm_resource_group.myresourcegroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = local.global_tags

  depends_on = [azurerm_resource_group.myresourcegroup]
}

## Create a storage container
## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
resource "azurerm_storage_container" "example" {
  name                  = local.storage_container_name
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"

  depends_on = [azurerm_resource_group.myresourcegroup]
}

## https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms
## please download bak to put on same folder as terraform files
## Create a storage blob
## upload the AdventureWorksLT2022.bak file to the storage container
## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob
resource "azurerm_storage_blob" "example" {
  name                   = "AdventureWorksLT2022.bak"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.example.name
  type                   = "Block"
  source                 = "AdventureWorksLT2022.bak"

  depends_on = [azurerm_storage_container.example]
}

