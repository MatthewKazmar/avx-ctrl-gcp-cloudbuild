terraform {
  backend "gcs" {
    bucket = "mk1-tfstate"
    prefix = "state/gateways"
  }
}