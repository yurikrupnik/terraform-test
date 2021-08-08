terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.78.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=2.1.2"
    }
  }
  //  random = {
  //    source  = "hashicorp/random"
  //    version = ">=2.2.1"
  //  }
  backend "gcs" {
    credentials = "terraform-sa-key.json"
    bucket  = "mussia8-terraform"
    prefix  = "prod"
  }
}

provider "google" {
  # credentials = "terraform-sa-key.json"
  //  credentials = file("<NAME>.json")

  project = var.project
  region  = var.location
  zone    = var.zone

}




//resource "google_project_iam_policy" "project" {
//  project     = var.project
//  policy_data = data.google_iam_policy.admin.policy_data
//}

resource "google_service_account" "data-developer" {
  account_id   = "data-developer"
  display_name = "My data developer service account"
}


resource "google_service_account" "bi-developer" {
  account_id   = "bi-developer"
  display_name = "My bi developer service account"
}

resource "google_project_iam_binding" "binding" {
  role    = "roles/run.developer"
  members = [
    "serviceAccount:${google_service_account.data-developer.email}"
  ]
}
resource "google_project_iam_binding" "binding1" {
  role    = "roles/cloudfunctions.developer"
  members = [
    "serviceAccount:${google_service_account.bi-developer.email}"
  ]
}


# data "google_iam_policy" "admin" {
#   binding {
#     # role = "allAuthenticatedUsers"
#     # role = "roles/iam.serviceAccountAdmin"
#     role = "roles/storage.objectViewer"
#     members = [
#       "user:CreativeAris99@gmail.com"
#     ]
#   }
# }

# resource "google_service_account_iam_policy" "admin-account-iam" {
#   service_account_id = google_service_account.data-developer.name
#   policy_data        = data.google_iam_policy.admin.policy_data
# }

// Give role of serviceAccountUser to CreativeAris99@gmail.com over the service account
resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = google_service_account.data-developer.name
  role               = "roles/iam.serviceAccountUser"

  members = [
    "user:CreativeAris99@gmail.com",
  ]
}



//output "damss" {
//  value = google_service_account.storage.name
//}
//output "dam" {
//  value = google_service_account.storage.id
//}
//
//output "dama" {
//  value = google_service_account.storage.email
//}
