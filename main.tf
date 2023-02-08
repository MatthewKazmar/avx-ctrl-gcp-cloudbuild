terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project     = var.project
  zone        = var.zone
}

# We need a json file for a service account in the workspace.
data "google_secret_manager_secret_version" "aviatrix" {
  secret = "avx-service-account"
}

resource "local_sensitive_file" "gcp_json" {
  filename = "gcp.json"
  content  = google_secret_manager_secret_version.aviatrix.secret_data
}

module "aviatrix-controller-gcp" {
  source                              = "AviatrixSystems/gcp-controller/aviatrix"
  access_account_name                 = var.project
  aviatrix_controller_admin_email     = var.aviatrix_controller_admin_email
  aviatrix_controller_admin_password  = var.aviatrix_controller_admin_password
  aviatrix_customer_id                = var.aviatrix_customer_id
  gcloud_project_credentials_filepath = resource.local_sensitive_file.gcp_json.filename
  incoming_ssl_cidrs                  = local.incoming_ssl_cidrs
  image                               = var.image
}