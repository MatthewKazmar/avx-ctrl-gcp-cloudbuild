terraform {
  backend "gcs" {
    bucket = "mk1-tfstate"
    prefix = "env/dev"
  }
}