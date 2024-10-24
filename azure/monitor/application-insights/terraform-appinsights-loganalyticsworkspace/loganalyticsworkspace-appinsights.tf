
# Create a Log Analytics Workspace
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = local.log_analytics_workspace_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"

  retention_in_days = 30

  tags = local.global_tags
}

# Create an Application Insights Resource linked to the Log Analytics Workspace
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights
resource "azurerm_application_insights" "ai" {
  name                = local.app_insights_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web" # Options: web, other, etc.

  # Link to the Log Analytics Workspace
  workspace_id = azurerm_log_analytics_workspace.law.id

  # Optional: Configure sampling
  sampling_percentage = 100.0

  tags = local.global_tags
}

# Output the Log Analytics Workspace ID
output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.id
}

# Output the Application Insights Instrumentation Key
output "application_insights_instrumentation_key" {
  description = "Instrumentation Key for the Application Insights resource"
  value       = azurerm_application_insights.ai.instrumentation_key
  sensitive = true
}

# Output the Application Insights Connection String
output "application_insights_connection_string" {
  description = "Connection String for the Application Insights resource"
  value       = azurerm_application_insights.ai.connection_string
  sensitive   = true
}


