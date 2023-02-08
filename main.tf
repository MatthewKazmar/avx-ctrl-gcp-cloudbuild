terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = var.gcloud_project_credentials_filepath
}

module "aviatrix-controller-gcp" {
  source                              = "AviatrixSystems/gcp-controller/aviatrix"
  access_account_name                 = var.access_account_name
  aviatrix_controller_admin_email     = var.aviatrix_controller_admin_email
  aviatrix_controller_admin_password  = var.aviatrix_controller_admin_password
  aviatrix_customer_id                = var.aviatrix_customer_id
  gcloud_project_credentials_filepath = var.gcloud_project_credentials_filepath
  incoming_ssl_cidrs                  = var.incoming_ssl_cidrs
  image                               = var.image
}