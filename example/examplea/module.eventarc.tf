# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "eventarc" {
  source           = "../../"
  project_id       = "pike-477416"
  location         = "europe-west2"
  run_service_name = "eventarc-target"
}
