# terraform-gcp-eventarc

Terraform module for Eventarc. Exercises holden's `policies/gcp/eventarc` policy set.

## Role and Permissions

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "cloudkms.cryptoKeys.getIamPolicy",
    "cloudkms.cryptoKeys.setIamPolicy",
    "eventarc.triggers.create",
    "eventarc.triggers.delete",
    "eventarc.triggers.get",
    "eventarc.triggers.update",
    "iam.serviceAccounts.create",
    "iam.serviceAccounts.delete",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.update",
    "monitoring.uptimeCheckConfigs.create",
    "monitoring.uptimeCheckConfigs.delete",
    "monitoring.uptimeCheckConfigs.get",
    "monitoring.uptimeCheckConfigs.update",
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",
    "resourcemanager.projects.setIamPolicy",
    "run.operations.get",
    "run.services.create",
    "run.services.delete",
    "run.services.get",
    "run.services.getIamPolicy",
    "run.services.setIamPolicy",
    "run.services.update"
  ]
}

# plan role
resource "google_project_iam_custom_role" "terraform_pike_plan" {
  project     = "pike-477416"
  role_id     = "terraform_pike_plan"
  title       = "terraform_pike_plan"
  description = "A user with least privileges"
  permissions = [
    "cloudkms.cryptoKeys.getIamPolicy",
    "eventarc.triggers.get",
    "iam.serviceAccounts.get",
    "monitoring.uptimeCheckConfigs.get",
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",
    "run.operations.get",
    "run.services.get",
    "run.services.getIamPolicy"
  ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->
