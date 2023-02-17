resource "google_compute_network" "avx_network" {
  count                   = local.create_vpc
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "avx_subnetwork" {
  count = local.create_vpc

  name          = local.subnetwork_name
  network       = google_compute_network.avx_network[0].id
  ip_cidr_range = var.subnetwork_cidr
  region        = var.subnetwork_region

  depends_on = [google_compute_network.avx_network]
}