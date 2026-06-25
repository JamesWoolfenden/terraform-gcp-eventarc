resource "google_cloud_run_v2_service" "target" {
  name     = var.run_service_name
  project  = var.project_id
  location = var.location

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}
