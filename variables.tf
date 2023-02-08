# Environment
variable "project" { type = string }
variable "zone" { type = string }
variable "aviatrix_controller_admin_email" { type = string }
variable "aviatrix_controller_admin_password" { type = string }
variable "aviatrix_customer_id" { type = string }
variable "controller_name" { type = string }
variable "incoming_ssl_cidrs" { type = string }
variable "image" { type = string }
variable "myip" { type = string}

locals {
  incoming_ssl_cidrs = concat(split(",", var.incoming_ssl_cidrs), "${var.myip}/32")
}