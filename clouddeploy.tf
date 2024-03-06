resource "google_clouddeploy_delivery_pipeline" "template-pipeline" {
  location    = "us-central1"
  name        = "${var.sigla}-template-pipeline"
  project     = "copelcicd"
  suspended   = false
  serial_pipeline {
    stages {
      profiles  = [google_clouddeploy_target.dev.target_id]
      target_id = google_clouddeploy_target.dev.target_id
    }
    stages {
      profiles  = [google_clouddeploy_target.hml.target_id]
      target_id = google_clouddeploy_target.hml.target_id
    }
    stages {
      profiles  = [google_clouddeploy_target.prd.target_id]
      target_id = google_clouddeploy_target.prd.target_id
    }
  }
}

resource "google_clouddeploy_automation" "promote-release-automation" {
  delivery_pipeline = google_clouddeploy_delivery_pipeline.template-pipeline.name
  location          = "us-central1"
  name              = "${var.sigla}-promote-release-automation"
  suspended         = false
  service_account   = "484283758360-compute@developer.gserviceaccount.com"
  rules {
    promote_release_rule {
      destination_target_id = "@next"
      id                    = "promote-release-rule"
    }
  }
  selector {
    targets {
      id     = google_clouddeploy_target.dev.target_id
    }
    targets {
      id     = google_clouddeploy_target.hml.target_id
    }
  }
}

resource "google_clouddeploy_target" "dev" {
  deploy_parameters = {}
  location          = "us-central1"
  name              = "${var.sigla}-dev"
  require_approval  = false
  execution_configs {
    artifact_storage  = "gs://us-central1.deploy-artifacts.copelcicd.appspot.com"
    execution_timeout = "3600s"
    usages            = ["RENDER", "DEPLOY", "VERIFY", "PREDEPLOY", "POSTDEPLOY"]
  }
  gke {
    cluster     = "projects/copelcicd/locations/us-central1/clusters/copeldev"
    internal_ip = false
  }
}

resource "google_clouddeploy_target" "hml" {
  deploy_parameters = {}
  location          = "us-central1"
  name              = "${var.sigla}-hml"
  require_approval  = false
  execution_configs {
    artifact_storage  = "gs://us-central1.deploy-artifacts.copelcicd.appspot.com"
    execution_timeout = "3600s"
    usages            = ["RENDER", "DEPLOY", "VERIFY", "PREDEPLOY", "POSTDEPLOY"]
  }
  gke {
    cluster     = "projects/copelcicd/locations/us-central1/clusters/copelstg"
    internal_ip = false
  }
}

resource "google_clouddeploy_target" "prd" {
  deploy_parameters = {}
  location          = "us-central1"
  name              = "${var.sigla}-prd"
  require_approval  = true
  execution_configs {
    artifact_storage  = "gs://us-central1.deploy-artifacts.copelcicd.appspot.com"
    execution_timeout = "3600s"
    usages            = ["RENDER", "DEPLOY", "VERIFY", "PREDEPLOY", "POSTDEPLOY"]
  }
  gke {
    cluster     = "projects/copelcicd/locations/us-east1/clusters/copelprd"
    internal_ip = false
  }
}
