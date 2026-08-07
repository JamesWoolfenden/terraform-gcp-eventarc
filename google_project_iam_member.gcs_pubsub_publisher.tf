data "google_storage_project_service_account" "gcs_account" {
  project = var.project_id
}

# Required for direct Cloud Storage events: GCS's own service agent must be
# able to publish to the Pub/Sub topic Eventarc creates behind this trigger.
# holden:ignore:HLD_GCP_260 — for a direct Cloud Storage event source (not a
# google.cloud.pubsub.topic.v1.messagePublished source), Eventarc always
# manages its own topic internally; the provider schema documents
# transport.pubsub.topic as user-suppliable only for pubsub-sourced triggers,
# so there is no topic to scope this grant to before the trigger exists.
# Google's own docs require this exact project-level grant as a prerequisite,
# ahead of trigger creation.
resource "google_project_iam_member" "gcs_pubsub_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}
