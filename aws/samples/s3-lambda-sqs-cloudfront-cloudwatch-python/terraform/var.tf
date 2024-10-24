# Purpose: Define variables for the Terraform configuration

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

  ## aws
  aws_region = "us-west-1"

  ## s3 bucket
  s3_bucket_name = "s3-bucket-dev"

  ## sqs queue
  s3_event_queue_name = "s3-event-queue-dev"

  ## cloudfront
  website_name = "subdomain-name-or-wwww.domain.com"



  ## todo add tags - please note azure did not support default_tags or global tage
  global_tags = {
    department_code = "abc" ## 3 digit department code
    environment     = "dev" ## dev, test, prod, development, production
    project_name    = "my-cloud-project" ## my-cloud-project limit 63 characters
    business_owner  = "cloud.ops@domain.com" ## email address limit 63 characters

    billing_code    = "111-abc" ## billing code AAA-PC-1
    cloud_type      = "commercial" ## cloud: commercial, government
  }
}
