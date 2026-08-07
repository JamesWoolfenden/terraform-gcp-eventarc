resource "google_eventarc_trigger" "main" {
  name            = var.trigger_name
  project         = var.project_id
  location        = var.location
  service_account = google_service_account.eventarc.email

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.storage.object.v1.finalized"
  }

  matching_criteria {
    attribute = "bucket"
    value     = var.source_bucket_name
  }

  destination {
    cloud_run_service {
      service = google_cloud_run_v2_service.target.name
      region  = var.location
    }
  }

  depends_on = [
    google_cloud_run_v2_service_iam_member.eventarc_invoke
  ]
}
