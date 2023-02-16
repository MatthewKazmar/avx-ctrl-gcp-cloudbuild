# We need a json file for a service account in the workspace.
data "google_secret_manager_secret_version" "aviatrix" {
  secret = var.avx_service_account_secret_name
}

resource "local_sensitive_file" "gcp_json" {
  filename = "gcp.json"
  content  = data.google_secret_manager_secret_version.aviatrix.secret_data
}

resource "aviatrix_account" "access_account" {
  account_name                        = var.project
  cloud_type                          = 4
  gcloud_project_id                   = var.project
  gcloud_project_credentials_filepath = "gcp.json"
}

#Security Group Management
resource "aviatrix_controller_security_group_management_config" "avx_sgm" {
  account_name                     = var.project
  enable_security_group_management = true
}