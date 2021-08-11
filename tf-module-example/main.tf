resource "google_service_account" "storage-admin" {
  account_id   = "sa-storage-admin"
  display_name = "My storage admin service account"
  description = "My storage admin SA"
}

resource "google_project_iam_binding" "storage-admin-binding" {
  role    = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.storage-admin.email}"
  ]
}



output "dam" {
  value = google_project_iam_binding.storage-admin-binding
}

output "storage" {
  value = google_service_account.storage-admin
}
