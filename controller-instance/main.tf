# Deploy Controller
resource "google_compute_address" "avx_controller_publicip" {
  name = local.public_ip_name
}

resource "google_compute_instance" "avx_controller_vm" {
  name                      = var.controller_name
  machine_type              = var.controller_machine_type
  zone                      = local.instance_zone
  tags                      = var.network_tags
  allow_stopping_for_update = true
  deletion_protection       = true

  boot_disk {
    initialize_params {
      image = var.controller_image
    }
  }

  network_interface {
    subnetwork = data.terraform_remote_state.network.subnetwork_selflink
    access_config {
      nat_ip = google_compute_address.avx_controller_publicip.address
    }
  }
}

resource "google_compute_firewall" "aviatrix_controller_firewall" {
  name          = local.firewall_rule_name
  network       = data.google_compute_subnetwork.avx_subnetwork.network
  source_ranges = local.admin_cidrs

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = var.network_tags
}
