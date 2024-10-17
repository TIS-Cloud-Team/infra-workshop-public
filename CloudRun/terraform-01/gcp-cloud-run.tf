resource "google_cloud_run_service" "cloudrun-1" {
  name     = local.cloudrun_name
  location = local.project_region

  template {
    spec {
      containers {
        image = local.image_name
        ports {
          container_port = local.image_http_port
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

output "cloud_run_url" {
  value = google_cloud_run_service.cloudrun-1.status[0].url
}