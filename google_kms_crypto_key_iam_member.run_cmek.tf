data "google_project" "target" {
  project_id = var.project_id
}

# Cloud Run's service agent (not the runtime service account) must hold this
# role on the CMEK key or the service fails to deploy.
resource "google_kms_crypto_key_iam_member" "run_cmek" {
  crypto_key_id = var.kms_key_id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.target.number}@serverless-robot-prod.iam.gserviceaccount.com"
}
