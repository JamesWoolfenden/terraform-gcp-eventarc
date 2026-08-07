
variable "project_id" {
  type        = string
  description = "Project that owns the Eventarc trigger and Cloud Run service"

  validation {
    condition     = length(trimspace(var.project_id)) > 0
    error_message = "var.project_id must be a non-empty string"
  }
}

variable "location" {
  type        = string
  description = "Location for the Eventarc trigger and Cloud Run service"
  default     = "europe-west2"

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "var.location must be a non-empty string"
  }
}

variable "run_service_name" {
  type        = string
  description = "Name of the Cloud Run service that receives events"

  validation {
    condition     = length(trimspace(var.run_service_name)) > 0
    error_message = "var.run_service_name must be a non-empty string"
  }
}

variable "kms_key_id" {
  description = "ID of the KMS CryptoKey used to encrypt the Cloud Run container image (CMEK)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(trimspace(var.kms_key_id)) > 0
    error_message = "var.kms_key_id must be a non-empty string"
  }
}

variable "container_image" {
  type        = string
  description = "Container image deployed to the Cloud Run service"
  default     = "us-docker.pkg.dev/cloudrun/container/hello:1"

  validation {
    condition     = length(trimspace(var.container_image)) > 0
    error_message = "var.container_image must be a non-empty string"
  }
}

variable "request_timeout" {
  type        = string
  description = "Maximum duration a request can take before Cloud Run times it out"
  default     = "300s"

  validation {
    condition     = length(trimspace(var.request_timeout)) > 0
    error_message = "var.request_timeout must be a non-empty string"
  }
}

variable "container_cpu_limit" {
  type        = string
  description = "CPU limit for the Cloud Run container"
  default     = "1"

  validation {
    condition     = length(trimspace(var.container_cpu_limit)) > 0
    error_message = "var.container_cpu_limit must be a non-empty string"
  }
}

variable "container_memory_limit" {
  type        = string
  description = "Memory limit for the Cloud Run container"
  default     = "512Mi"

  validation {
    condition     = length(trimspace(var.container_memory_limit)) > 0
    error_message = "var.container_memory_limit must be a non-empty string"
  }
}

variable "vpc_subnetwork" {
  type        = string
  description = "Self link or ID of the subnetwork used for Cloud Run direct VPC egress"

  validation {
    condition     = length(trimspace(var.vpc_subnetwork)) > 0
    error_message = "var.vpc_subnetwork must be a non-empty string"
  }
}

variable "vpc_egress" {
  type        = string
  description = "Egress setting for Cloud Run direct VPC access. ALL_TRAFFIC requires the target subnetwork's network to already have Cloud NAT (or another controlled internet egress path) configured by the caller."
  default     = "PRIVATE_RANGES_ONLY"

  validation {
    condition     = contains(["ALL_TRAFFIC", "PRIVATE_RANGES_ONLY"], var.vpc_egress)
    error_message = "var.vpc_egress must be one of: ALL_TRAFFIC, PRIVATE_RANGES_ONLY"
  }
}

variable "source_bucket_name" {
  type        = string
  description = "Name of the Cloud Storage bucket whose finalized-object events trigger this Eventarc pipeline"

  validation {
    condition     = length(trimspace(var.source_bucket_name)) > 0
    error_message = "var.source_bucket_name must be a non-empty string"
  }
}

variable "min_instance_count" {
  type        = number
  description = "Minimum number of warm Cloud Run instances (0 allows scale-to-zero)"
  default     = 0

  validation {
    condition     = var.min_instance_count >= 0
    error_message = "var.min_instance_count must be >= 0"
  }
}

variable "trigger_name" {
  type        = string
  description = "Name of the Eventarc trigger"
  default     = "storage-trigger"

  validation {
    condition     = length(trimspace(var.trigger_name)) > 0
    error_message = "var.trigger_name must be a non-empty string"
  }
}

variable "eventarc_service_account_id" {
  type        = string
  description = "account_id for the Eventarc trigger's service account"
  default     = "eventarc-trigger"

  validation {
    condition     = length(trimspace(var.eventarc_service_account_id)) > 0
    error_message = "var.eventarc_service_account_id must be a non-empty string"
  }
}

variable "max_instance_count" {
  type        = number
  description = "Maximum number of Cloud Run instances"
  default     = 10

  validation {
    condition     = var.max_instance_count > 0
    error_message = "var.max_instance_count must be > 0"
  }
}