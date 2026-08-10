resource "google_service_account" "eventarc" {
  project      = var.project_id
  account_id   = var.eventarc_service_account_id
  display_name = "Eventarc trigger service account"
}
