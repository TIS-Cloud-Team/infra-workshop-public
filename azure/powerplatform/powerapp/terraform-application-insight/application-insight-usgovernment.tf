provider "azurerm" {
  features {}
  environment = "usgovernment"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-example-resources"
  location = "USGov Virginia"
}

resource "azurerm_application_insights" "example" {
  name                = "appinsights-examples"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

output "instrumentation_key" {
  value = azurerm_application_insights.example.instrumentation_key
}