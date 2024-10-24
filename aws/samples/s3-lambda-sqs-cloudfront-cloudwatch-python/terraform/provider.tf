## provider.tf
provider "aws" {
  region = local.aws_region
  ## profile = "your_profile_name"
}

# Path: aws/samples/s3-lambda-sqs-cloudfront-cloudwatch-python/terraform/variables.tf
data "aws_caller_identity" "current" {}

## 
output "caller_identity" {
  description = "The caller identity"
  value       = data.aws_caller_identity.current
}

output "account_id" {
  description = "The AWS Account ID number of the account that owns or contains the calling entity"
  value       = data.aws_caller_identity.current.account_id
}

output "user_id" {
  description = "The unique identifier of the calling entity"
  value       = data.aws_caller_identity.current.user_id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the calling entity"
  value       = data.aws_caller_identity.current.arn
}



## centralized teffraform state location

## state save in azure storage account
## https://www.terraform.io/docs/backends/types/azurerm.html
# terraform {
#  backend "azurerm" {
#    subscription_id       = "f3b3b3b3-3b3b-3b3b-3b3b-3b3b3b3b3b3b"
#    resource_group_name   = "resource-group-name"
#    storage_account_name  = "storgeaccountname"
#    container_name        = "blob-container-name"
#    key                   = "statefile.tfstate"
#    access_key            = "accesskey"
#  }
# }

