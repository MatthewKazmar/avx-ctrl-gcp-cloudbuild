terraform {
  required_providers {
    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = "~>3.00.0"
    }
  }
}

provider aviatrix {
  controller_ip = data.terraform_remote_state.controller.module.aviatrix-controller-gcp.public_ip
  username = "admin"
  password = var.aviatrix_controller_admin_password
}

data "terraform_remote_state" "controller" {
  backend = "gcs"
  config = {
    bucket = "mk1-tfstate"
    prefix = "state/controller"
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