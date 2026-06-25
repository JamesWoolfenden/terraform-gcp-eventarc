resource "google_service_account" "eventarc" {
  project      = var.project_id
  account_id   = "eventarc-trigger"
  display_name = "Eventarc trigger service account"
}