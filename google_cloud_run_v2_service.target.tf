resource "google_cloud_run_v2_service" "target" {
  name     = var.run_service_name
  project  = var.project_id
  location = var.location

  binary_authorization {
    use_default = true
  }

  template {
    encryption_key  = var.kms_key_id
    service_account = google_service_account.run_service.email
    timeout         = var.request_timeout

    vpc_access {
      network_interfaces {
        subnetwork = var.vpc_subnetwork
      }
      egress = var.vpc_egress
    }

    scaling {
      min_instance_count = var.min_instance_count
      max_instance_count = var.max_instance_count
    }

    containers {
      image = var.container_image

      resources {
        limits = {
          cpu    = var.container_cpu_limit
          memory = var.container_memory_limit
        }
      }
    }
  }

  depends_on = [
    google_kms_crypto_key_iam_member.run_cmek
  ]
}

resource "google_service_account" "run_service" {
  account_id   = "${var.run_service_name}-sa"
  display_name = "Service account for Cloud Run service ${var.run_service_name}"
  project      = var.project_id
}

resource "google_monitoring_uptime_check_config" "target" {
  project      = var.project_id
  display_name = "${var.run_service_name}-uptime-check"
  timeout      = "10s"
  period       = "60s"

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = replace(google_cloud_run_v2_service.target.uri, "https://", "")
    }
  }

  http_check {
    path    = "/"
    port    = 443
    use_ssl = true
  }
}
