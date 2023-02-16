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