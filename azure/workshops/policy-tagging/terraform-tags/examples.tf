resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"

  tags = {
    Environment = "Production"
    Department  = "Finance"
  }
}


variable "common_tags" {
  type = map(string)
  default = {
    Environment = "Production"
    Department  = "Finance"
  }
}

resource "azurerm_virtual_machine" "example" {


    tags = var.common_tags
}



locals {
  base_tags = {
    Environment = "Production"
  }
}

resource "azurerm_storage_account" "example" {
  // ... other configuration ...

  tags = merge(
    local.base_tags,
    {
      "Project" = "TerraformDemo"
    }
  )
}