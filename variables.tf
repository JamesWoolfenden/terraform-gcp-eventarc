
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
}

variable "run_service_name" {
  type        = string
  description = "Name of the Cloud Run service that receives events"

  validation {
    condition     = length(trimspace(var.run_service_name)) > 0
    error_message = "var.run_service_name must be a non-empty string"
  }
}