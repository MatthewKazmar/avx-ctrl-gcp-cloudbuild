variable "project" {
  type        = string
  description = "Google Cloud Project for deployment"
}

variable "network_tags" {
  type        = set(string)
  description = "Network tags to assign to the Aviatrix Controller Instance"
  default     = ["avx-controller"]
}

data "terraform_remote_state" "instance" {
  backend = "gcs"
  config = {
    state_bucket = var.state_bucket
    prefix       = "${var.state_prefix}/instance"
  }
}