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

  ## gcp project region and name
  project_region = "us-west1"  
  project_name = "gcp-project-name"

  ## google compute network name, cloud run name and gke cluster name
  google_compute_network_name = "gcn-${local.app_name}"
  cloudrun_name = "cloudrun-${local.app_name}"
  gke_cluster_name = "gke-cluster-${local.app_name}"
  gke_cluster_size = "e2-small"

  ## image name and port
  # us-docker.pkg.dev/cloudrun/container/hello
  image_name = "us-docker.pkg.dev/cloudrun/container/hello" ##"gcr.io/cloudrun/hello"
  image_http_port = 8080 ##8080
}
