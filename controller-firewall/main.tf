#This code is designed to add the cloud build worker to the GCP firewall.
#The idea is to run the apply at the beginning, then destroy at the end of the step.

# Get my public IP
data "http" "buildip" {
  url = "http://icanhazip.com"
}

resource "google_compute_firewall" "aviatrix_cloudbuild" {
  name          = "avx-cloudbuild-temp-rule"
  network       = data.terraform_remote_state.instance.outputs.controller_network
  source_ranges = [chomp(data.http.buildip.response_body)]
  #source_ranges = ["${data.http.buildip.response_body}/32"]
  #source_ranges = [var.worker_ip]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = var.network_tags
}

resource "local_file" "public_ip" {
  content  = data.terraform_remote_state.instance.outputs.controller_public_ip
  filename = "/workspace/controller_public_ip"
}

resource "local_file" "private_ip" {
  content  = data.terraform_remote_state.instance.outputs.controller_private_ip
  filename = "/workspace/controller_private_ip"
}