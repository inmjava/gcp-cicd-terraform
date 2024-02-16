provider "google" {
  project     = "copelcicd"
  region      = "us-central1"
}

resource "google_sourcerepo_repository" "my-repo" {
  name = "projeto/${var.sigla}"
}