# Environment
variable "project" { type = string }
variable "region" { type = string }

variable "aviatrix_controller_admin_email" { type = string }
variable "aviatrix_controller_admin_password" { type = string }
variable "aviatrix_customer_id" { type = string }
variable "controller_name" { type = string }
variable "incoming_ssl_cidrs" { type = list(any) }
variable "image" { type = string }

locals {
  incoming_ssl_cidrs = split(",", var.incoming_ssl_cidrs)
}