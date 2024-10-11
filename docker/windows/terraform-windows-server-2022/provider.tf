terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  ## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

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