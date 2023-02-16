terraform {
  backend "gcs" {
    state_bucket = var.state_bucket
    prefix       = "${var.state_prefix}/instance"
  }
}