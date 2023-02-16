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

variable "avx_service_account_secret_name" {
  type        = string
  description = "Name of the secret that contains the Aviatrix Service Account json."
  default     = "avx-service-account"
}