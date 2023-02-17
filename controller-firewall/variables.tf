variable "project" {
  type        = string
  description = "Google Cloud Project for deployment"
}

variable "state_bucket" {
  type        = string
  description = "State bucket for Remote State."
}

# variable "worker_ip" {
#   type        = string
#   description = "State bucket for Remote State."
# }

variable "network_tags" {
  type        = set(string)
  description = "Network tags to assign to the Aviatrix Controller Instance"
  default     = ["avx-controller"]
}

data "terraform_remote_state" "instance" {
  backend = "gcs"
  config = {
    bucket = var.state_bucket
    prefix = "avx/instance"
  }
}