# HLD_GCP_297: trigger service account must hold roles/run.invoker on the destination
resource "google_cloud_run_v2_service_iam_member" "eventarc_invoke" {
  project  = var.project_id
  location = var.location
  name     = google_cloud_run_v2_service.target.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.eventarc.email}"
}
