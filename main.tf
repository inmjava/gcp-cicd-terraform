provider "google" {
  project     = "copelcicd"
  region      = "us-central1"
}

resource "google_sourcerepo_repository" "my-repo" {
  name = "projeto/${var.sigla}"
}

resource "google_cloudbuild_trigger" "filename-trigger" {
  location = "global"
  name = "${var.sigla}-trigger"

  trigger_template {
    branch_name = "master"
    repo_name   = google_sourcerepo_repository.my-repo.name
  }

  filename = "cloudbuild.yaml"
}


