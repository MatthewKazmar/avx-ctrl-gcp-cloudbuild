terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = "~>3.00.0"
    }
  }
}

provider "aviatrix" {
  controller_ip = data.terraform_remote_state.controller.outputs.public_ip
  username      = "admin"
  password      = var.aviatrix_controller_admin_password
}

provider "google" {
  project = var.project
}

data "terraform_remote_state" "controller" {
  backend = "gcs"
  config = {
    state_bucket = "mk1-tfstate"
    prefix       = "state/controller"
  }
}

resource "aviatrix_controller_security_group_management_config" "aviatrix_sgm" {
  account_name                     = var.project
  enable_security_group_management = true
}

resource "google_compute_firewall" "gateways-worker" {
  name = "gateways-worker"

  network       = var.network_name
  source_ranges = ["${var.myip}/32"]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

module "transit_non_ha_gcp" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.4.1"

  cloud   = "gcp"
  name    = "transit-non-ha-gcp"
  region  = "us-east1"
  cidr    = "10.1.0.0/23"
  account = var.project
  ha_gw   = false
}