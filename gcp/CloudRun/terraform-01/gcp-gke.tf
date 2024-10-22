resource "google_container_cluster" "my-gke-cluster" {
  name                 = local.gke_cluster_name
  location             = local.project_region
  network              = google_compute_network.my-google-compute-network.self_link
  subnetwork           = google_compute_subnetwork.my-gcn-subnet-10-16-12-0x24.self_link
  deletion_protection  = false

  node_pool {
    name       = "default-pool"
    node_count = 1

    node_config {
      machine_type = local.gke_cluster_size
      oauth_scopes = [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/trace.append",
        "https://www.googleapis.com/auth/cloud-platform",
      ]
    }
  }

  depends_on = [ google_compute_subnetwork.my-gcn-subnet-10-16-12-0x24 ]
}

output "cluster_name" {
  value = google_container_cluster.my-gke-cluster.name
}

output "cluster_endpoint" {
  value = google_container_cluster.my-gke-cluster.endpoint
}

output "cluster_ca_certificate" {
  value = base64decode(google_container_cluster.my-gke-cluster.master_auth[0].cluster_ca_certificate)
}
