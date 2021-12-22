locals {
  # service_account =   "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${var.service_account_name}]"
  gke_sa_linking_name = "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${var.service_account_name}]"
  all_service_account_roles = concat(var.service_account_roles, [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ])
}

resource "google_service_account" "a" {
  account_id   = var.service_account_name
  display_name = "Service Account for Cloud Storage Access"
}


resource "google_service_account_iam_binding" "a" {
  # for_each = toset(local.all_service_account_roles)

  service_account_id = google_service_account.a.name
  # role               = each.value
  # role               = "roles/storage.objectAdmin"
  role = "roles/iam.workloadIdentityUser"
  members = [
    # This needs to be targeted to the full IAM principal
    # This maps GCP->GKE Service Accounts
    local.gke_sa_linking_name,
  ]
}

resource "google_project_iam_binding" "project" {
  for_each = toset(local.all_service_account_roles)

  project = var.project_id
  # role    = "roles/storage.objectAdmin"
  role = each.value

  members = [
    "serviceAccount:${google_service_account.a.email}"
  ]
}

