##  azure app service on windows platform
##  dotnet framework v3.5 - compatibility with dotnet v2.0
##  3 virtual application created
##  for 'main' production slot and 2 deployment slots "stage' and 'dev' 

## https://learn.microsoft.com/en-us/azure/app-service/
## https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans
resource "azurerm_service_plan" "example" {
  name                = local.appservice_plan ## 
  location            = azurerm_resource_group.myresourcegroup.location #data.azurerm_resource_group.existing.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name #data.azurerm_resource_group.existing.name
  os_type = "Windows" ## Linux, WindowsContainer
  ## https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans
  sku_name =local.appservice_plan_sku_name  ## P1v2 S1 B1 Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, I4v2, I5v2, I6v2, P1v2, P2v2, P3v2, P0v3, P1v3, P2v3, P3v3, P1mv3, P2mv3, P3mv3, P4mv3, P5mv3, S1, S2, S3, SHARED, EP1, EP2, EP3, FC1, WS1, WS2, WS3, and Y1.
  #sku {
  #  tier = "Standard"
  #  size = "S1"
  #}

  tags = local.global_tags
}

## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app
resource "azurerm_windows_web_app" "example" {
  name                    = local.appservice_name ##"dt-mission-intranetdirectory-delete"
  location                = azurerm_resource_group.myresourcegroup.location #data.azurerm_resource_group.existing.location
  resource_group_name     = azurerm_resource_group.myresourcegroup.name #data.azurerm_resource_group.existing.name
  service_plan_id         = azurerm_service_plan.example.id
  client_affinity_enabled = true
  https_only              = true

  ## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service#always_on
  site_config {
    ## default-preload
    virtual_application {
      virtual_path = "/"
      physical_path = "site\\wwwroot"
      preload = true
    }
    virtual_application {
      virtual_path = "/IntranetDirectory"
      physical_path = "site\\wwwroot\\app1"
      preload = false
    }
    virtual_application {
      virtual_path = "/SFGovWebService"
      physical_path = "site\\wwwroot\\app2"
      preload = false
    }
    virtual_application {
      virtual_path = "/SFGovWebTemplateService"
      physical_path = "site\\wwwroot\\virtualapp3"
      preload = false
    }

    always_on                   = true
    ## Error: expected site_config.0.dotnet_framework_version to be one of ["v2.0" "v4.0" "v5.0" "v6.0"], got v3.5
    ##dotnet_framework_version    = "v2.0"
    http2_enabled                = false
    minimum_tls_version             = "1.2"
    ##websockets_enabled          = false
  
    use_32_bit_worker   = true
    # Enable session affinity (sticky sessions)
    
    application_stack {
        current_stack = "dotnet"
        dotnet_version = local.appservice_plan_dotnet_version
    }  

    ##scm_type = "LocalGit"

    ##default_documents = ["Default.htm","default.html", "default.aspx", "index.htm", "index.html", "hostingstart.html"]
    
  }

  ## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service
  app_settings = {
    "WEBSITE_ENABLE_32BIT" = "true"
    "SCM_USE_BASIC_AUTH"   = "true"   # Enable SCM basic auth
    "FTP_USE_BASIC_AUTH"   = "true"   # Enable FTP basic auth
    # Add your Application Insights Instrumentation Key
    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.example.instrumentation_key
  }

  tags = local.global_tags
}


output "aspnet_app_service_url" {
  value = azurerm_windows_web_app.example.default_hostname
}

output "aspnet_app_service_outbound_ip_addr" {
  value = azurerm_windows_web_app.example.outbound_ip_addresses
}