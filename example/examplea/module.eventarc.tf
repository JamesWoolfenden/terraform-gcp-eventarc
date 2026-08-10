# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "eventarc" {
  source             = "../../"
  project_id         = "pike-477416"
  location           = "europe-west2"
  run_service_name   = "eventarc-target"
  kms_key_id         = google_kms_crypto_key.eventarc.id
  vpc_subnetwork     = google_compute_subnetwork.eventarc.id
  source_bucket_name = google_storage_bucket.eventarc.name
}

resource "google_storage_bucket" "eventarc" {
  name                        = "pike-477416-eventarc"
  location                    = "europe-west2"
  uniform_bucket_level_access = true
  force_destroy               = false
  public_access_prevention    = "enforced"

  encryption {
    default_kms_key_name = google_kms_crypto_key.eventarc.id
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "Delete"
    }
  }

  soft_delete_policy {
    retention_duration_seconds = 604800
  }

  logging {
    log_bucket = google_storage_bucket.eventarc_logs.name
  }
}

# holden:ignore:HLD_GCP_003 — this bucket is itself the access-log
# destination for google_storage_bucket.eventarc; GCS does not support a
# bucket logging to itself.
resource "google_storage_bucket" "eventarc_logs" {
  name                        = "pike-477416-eventarc-logs"
  location                    = "europe-west2"
  uniform_bucket_level_access = true
  force_destroy               = false
  public_access_prevention    = "enforced"

  encryption {
    default_kms_key_name = google_kms_crypto_key.eventarc.id
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "Delete"
    }
  }

  soft_delete_policy {
    retention_duration_seconds = 604800
  }
}

resource "google_kms_key_ring" "eventarc" {
  name     = "eventarc"
  location = "europe-west2"
}

resource "google_kms_crypto_key" "eventarc" {
  name            = "eventarc"
  key_ring        = google_kms_key_ring.eventarc.id
  rotation_period = "7776000s" # 90 days

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_network" "eventarc" {
  name                            = "eventarc"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
}

resource "google_compute_router" "eventarc" {
  name    = "eventarc-router"
  network = google_compute_network.eventarc.name
  region  = "europe-west2"
}

resource "google_compute_router_nat" "eventarc" {
  name                               = "eventarc-nat"
  router                             = google_compute_router.eventarc.name
  region                             = "europe-west2"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_firewall" "eventarc_allow_internal" {
  name    = "eventarc-allow-internal"
  network = google_compute_network.eventarc.id

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/24"]

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "eventarc" {
  name                     = "eventarc"
  network                  = google_compute_network.eventarc.id
  region                   = "europe-west2"
  ip_cidr_range            = "10.0.0.0/24"
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
