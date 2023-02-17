variable "project" {
  type        = string
  description = "Google Cloud Project for deployment"
}

variable "network_name" {
  type        = string
  description = "Name of the VPC to deploy."
  default     = "aviatrix-management"
}

variable "subnetwork_region" {
  type        = string
  description = "Region for Aviatrix subnetwork."
  default     = "us-central1"
}

variable "subnetwork_cidr" {
  type        = string
  description = "CIDR for Aviatrix subnetwork."
  default     = "192.168.20.0/24"
}

variable "subnetwork_self_link" {
  type        = string
  description = "Self link for the subnetwork. If blank, the network is created."
  default     = ""
}

locals {
  subnetwork_name = "${var.network_name}-subnet"
  create_vpc      = var.subnetwork_self_link == "" ? 1 : 0
}