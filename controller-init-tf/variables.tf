variable "project" {
  type        = string
  description = "Google Cloud Project for deployment"
}

variable "avx_service_account_secret_name" {
  type        = string
  description = "Name of the secret that contains the Aviatrix Service Account json."
  default     = "avx-service-account"
}