terraform {
  backend "gcs" {
    state_bucket = "mk1-tfstate"
    prefix       = "state/gateways"
  }
}