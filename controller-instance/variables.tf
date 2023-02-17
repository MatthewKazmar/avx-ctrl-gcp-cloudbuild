variable "project" {
  type        = string
  description = "Google Cloud Project for deployment"
}

variable "state_bucket" {
  type        = string
  description = "State bucket for Remote State."
}

variable "admin_cidrs" {
  type        = string
  description = "Allow admin access (HTTPS) to Aviatrix Controller."
}

variable "network_tags" {
  type        = set(string)
  description = "Network tags to assign to the Aviatrix Controller Instance"
  default     = ["avx-controller"]
}

variable "controller_name" {
  type        = string
  description = "The Aviatrix Controller's name."
  default     = "aviatrix-controller"
}

variable "controller_image" {
  type        = string
  description = "Aviatrix base image for the controller."
  default     = "aviatrix-public/avx-controller-gcp-2022-10-31"
}

variable "controller_machine_type" {
  type        = string
  description = "Size for Aviatrix Controller Compute Instance"
  default     = "n2d-standard-2"
}

variable "zone" {
  type        = string
  description = "Zone letter for the instance. Region is derived from the subnetwork supplied."
  default     = "c"
}

data "terraform_remote_state" "network" {
  backend = "gcs"
  config = {
    bucket = var.state_bucket
    prefix = "avx/network"
  }
}

data "google_compute_subnetwork" "avx_subnetwork" {
  self_link = data.terraform_remote_state.network.outputs.subnetwork_self_link
}

locals {
  public_ip_name     = "${var.controller_name}-publicip"
  firewall_rule_name = "${var.controller_name}-adminaccess"
  instance_zone      = "${data.google_compute_subnetwork.avx_subnetwork.region}-${var.zone}"
  admin_cidrs        = split(",", var.admin_cidrs)
}