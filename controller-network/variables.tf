variable "project" {
  type        = string
  description = "Google Cloud Project for deployment"
}

variable "state_bucket" {
  type        = string
  description = "Name of storage state_bucket for remote state."
}

variable "state_prefix" {
  type        = string
  description = "Prefix for states from the Aviatrix deployment."
  default     = "aviatrix/"
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
  state_prefix = "${var.state_prefix}/network"
  subnetwork_name = "${var.network_name}-subnet"
  create_vpc      = var.subnetwork_self_link == "" ? 1 : 0
}