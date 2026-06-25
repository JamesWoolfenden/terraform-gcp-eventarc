output "trigger_id" {
  value       = google_eventarc_trigger.main.id
  description = "ID of the Eventarc trigger"
}

output "service_account_email" {
  value       = google_service_account.eventarc.email
  description = "Email of the Eventarc trigger service account"
}
