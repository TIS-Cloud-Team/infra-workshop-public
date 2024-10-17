

resource "google_compute_network" "my-google-compute-network" {
  name                    = local.google_compute_network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "my-gcn-subnet-10-16-12-0x24" {
  name          = "my-gcn-subnet-10-16-12-0x24"
  ip_cidr_range = "10.16.12.0/24"
  region        = local.project_region
  network       = google_compute_network.my-google-compute-network.self_link

  #secondary_ip_range {
  #  range_name    = "pods"
  #  ip_cidr_range = "10.16.13.0/24"
  #}

  #secondary_ip_range {
  #  range_name    = "services"
  #  ip_cidr_range = "10.16.14.0/24"
  #}

}




