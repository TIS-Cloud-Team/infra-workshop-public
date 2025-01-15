
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

locals {
  ## app name, common prefix for all resources , please comment this line if you want to use default value  
  app_name = random_pet.prefix.id

  ## resource group 
  rg_location = "West US"  
  rg_name = "rg-${local.app_name}"

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
  db_license_type                 = "BasePrice"    ## LicenseIncluded, BasePrice
  db_sku_name                     = "GP_Gen5" ## GP_Gen5, BC_Gen5, MO_Gen5, MO_Gen4, HS_Gen4, DS_Gen4, DS_Gen5, BC_Gen4, GP_Gen4, HS_Gen5
  db_vcores                       = 4 ## 4, 8, 16, 24, 32, 40, 64
  db_storage_size_in_gb           = 32 ## 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536

  sqlmi_vpn_cidr="0.0.0.0/0"

  ## azure sql admin user name and password 
  db_user = "sqladmin" ## replace with your own sql server admin/sa account
  db_password = random_password.password.result

  entra_id_admin = "fname.lname_domain.com#EXT#@tenant_name.onmicrosoft.com" ##"EXT fname.lname@domain.com" ## replace with your own entra id admin user - please note this is user_principal_name

  ## sql database name
  db_name = "db-${local.app_name}"

  ## azure storage account
  ## storacctfor... azure storage account name contains only lowercase letters and numbers - must startwith character, storageaacct 24 character limits
  app_name_cleaned = replace(replace(replace(local.app_name, "_", ""), "-", ""), "'", "")
  storage_account_name = lower("storacct4${local.app_name_cleaned}") 
  storage_container_name = "sqlbackup"

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



## centralized terraform state location
##terraform {
##  backend "azurerm" {
##    subscription_id       = ""  ## subscription id
##    resource_group_name   = "" ## resource group name 
##    storage_account_name  = "" ## storage account name
##    container_name        = "" ## container name
##    key                   = "" ## blob name
##    access_key            = "" ## storage account access key
##  }
##}