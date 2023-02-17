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

provider "google" {
  project = var.project
}

provider "aviatrix" {
  controller_ip = data.terraform_remote_state.instance.outputs.controller_public_ip
}