
resource "random_pet" "prefix" {
  length = 1
}

resource "random_password" "password" {
  length      = 10
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 0
  special     = false ##true
}

variable "myAppName" {
  description = "my app name"
  type        = string
  default     = ""
}

# Generate random text for a unique storage account name
#resource "random_id" "random_id" {
#  keepers = {
#    # Generate a new ID only when a new resource group is defined
#    resource_group = azurerm_resource_group.rg.name
#  }

#  byte_length = 8
#}

locals {
  current_datetime = formatdate("YYMMDDhhmm", timestamp())
  app_name = random_pet.prefix.id

  ## resource group 
  rg_location = "West US"  
  rg_name = "rg-${local.app_name}"

  ## windows server 2022 data center vm
  vm_name="winsrv2022-${local.app_name}"  ## computer_name" can be at most 15 characters
  ## Truncate vm_name to ensure it does not exceed 15 characters
  vm_computer_name = substr(local.vm_name, 0, 15)
  vm_osdisk_name = "winsrv2022-OsDisk-${local.app_name}"
  vm_admin_username = "adminuser"
  vm_admin_password = random_password.password.result
  vm_size = "Standard_B2s" ## Standard_DS1_v2
  vm_source_image = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  ## acr name
  azure_container_name = "acr${local.app_name}${local.current_datetime}"


  ## aure app service
  appservice_name = "appservice-${local.app_name}"
  appservice_plan = "appservice-plan-${local.app_name}"
  appservice_plan_sku_name = "B1" ## P1v2 S1 B1
  appservice_plan_dotnet_version = "v4.0" ## v2.0 v4.0 v5.0 v6.0
  appservice_app_insights_name = "app-insights-${local.app_name}"
  
  ## azure sql server with or without elastic pool
  db_azure_sql_name = "sql-server-azure-sql-database"
  db_azure_sql_elastic_pool_name = "sql-server-elastic-pool-${local.app_name}"

  ## azure sql managed instance  
  db_azure_sql_mi_name = "sql-mi-${local.app_name}"

  ## azure sql admin user name and password 
  db_user = "sqladmin" ## replace with your own sql server admin/sa account
  db_password = random_password.password.result

  entra_id_admin = "fname.lname_domain.com#EXT#@tenant_name.onmicrosoft.com" ##"EXT fname.lname@domain.com" ## replace with your own entra id admin user - please note this is user_principal_name

  ## sql database name
  db_name = "db-${local.app_name}"

  ## todo add tags - please note azure did not support default_tags or global tage
  global_tags = {
    department_code = "abc" ## 3 digit department code
    environment     = "dev" ## dev, test, prod, development, production
    project_name    = "my-cloud-project" ## my-cloud-project limit 63 characters
    business_owner  = "cloud.ops@domain.com" ## email address limit 63 characters

    billing_code    = "111-abc" ## billing code
    cloud_type      = "commercial" ## cloud: commercial, government
  }
}