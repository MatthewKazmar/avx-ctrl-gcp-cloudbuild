terraform {
  backend "gcs" {
    bucket = var.state_bucket
    prefix = local.state_prefix
  }
}