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
//  backend "gcs" {
//    credentials = "terraform-sa-key.json"
//    bucket  = "mussia8-terraform"
//    prefix  = "prod"
//  }
}

provider "google" {
  # credentials = "terraform-sa-key.json"
  //  credentials = file("<NAME>.json")


  project = var.project
  region  = var.location
  zone    = var.zone

}

variable "ads" {
  default = "do it"
}

locals {
  dos = "ads"
}

data "google_iam_role" "roleinfo" {
  name = var.publisher
}

//data "google_client_config" "current" {
//}
//
//output "project" {
//  value = data.google_client_config.current.project
//}

//output "the_role_permissions" {
//  value = data.google_iam_role.roleinfo
//}
//output "the-google_service_account" {
//  value = google_service_account.data-developer
//}

// STORAGE TEST
resource "google_service_account" "storage-admin" {
  account_id   = "storage-admin"
  display_name = "My storage admin service account"
}

resource "google_project_iam_binding" "storage-admin-binding" {
  role    = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.storage-admin.email}"
  ]
}
// STORAGE TEST end


resource "google_service_account" "genera-sa" {
  account_id   = "general-sa"
  display_name = "My data developer service account"
}

resource "google_service_account" "data-developer" {
  account_id   = "data-developer"
  display_name = "My data developer service account"
}

resource "google_service_account" "bi-developer" {
  account_id   = "bi-developer"
  display_name = "My bi developer service account"
}

resource "google_project_iam_binding" "binding" {
  role    = data.google_iam_role.roleinfo.id
//  role    = "roles/pubsub.publisher"
  members = [
    "serviceAccount:${google_service_account.data-developer.email}"
  ]
}

resource "google_project_iam_binding" "binding1" {
  role    = var.cf-developer
  members = [
    "serviceAccount:${google_service_account.bi-developer.email}"
  ]
}

resource "google_project_iam_binding" "binding3" {
//  role    = var.publisher
  role    = "roles/iam.serviceAccountTokenCreator"
  members = [
    "serviceAccount:${google_service_account.genera-sa.email}",
    "user:krupnik.yuri@gmail.com"
  ]
}

// Allow bi-developer service to createtockens for data-developer
resource "google_service_account_iam_binding" "token-creator-iam" {
//  service_account_id = "projects/-/serviceAccounts/${google_service_account.data-developer.email}"
  service_account_id = google_service_account.data-developer.id
  role               = "roles/iam.serviceAccountTokenCreator"
  members = [
    "serviceAccount:${google_service_account.bi-developer.email}",
  ]
}


data "google_client_config" "default" {
  provider = google
}

//data "google_service_account_access_token" "default" {
////  provider               = google
////  target_service_account = "github-acc@mussia8.iam.gserviceaccount.com"
//  target_service_account = "yuris-persona-sa@mussia8.iam.gserviceaccount.com"
////  target_service_account = google_service_account.genera-sa.email
//  scopes                 = ["cloud-platform"]
//  lifetime               = "300s"
//}


provider "google" {
  alias        = "impersonated"
//  access_token = data.google_service_account_access_token.default.access_token
}
//
data "google_client_openid_userinfo" "me" {
  provider = google.impersonated
}
//
output "target-email" {
  value = data.google_client_openid_userinfo.me.email
}

//resource "google_service_account_iam_binding" "token-creator-iam" {
//  service_account_id = "projects/-/serviceAccounts/service_B@projectB.iam.gserviceaccount.com"
//  role               = "roles/iam.serviceAccountTokenCreator"
//  members = [
//    "serviceAccount:service_A@projectA.iam.gserviceaccount.com",
//  ]
//}

//resource "google_project_iam_policy" "project" {
//  project     = var.project
//  policy_data = data.google_iam_policy.admin.policy_data
//}
//
//data "google_iam_policy" "admin" {
//  binding {
//    role = "roles/compute.instanceAdmin"
//
//    members = [
//      "user:CreativeAris99@gmail.com",
//    ]
//  }
//}
//resource "google_project_iam_policy" "project" {
//  project     = var.project
//  policy_data = data.google_iam_policy.admin.policy_data
//}

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
//resource "google_service_account_iam_binding" "admin-account-iam" {
//  service_account_id = google_service_account.data-developer.name
//  role               = "roles/iam.serviceAccountUser"
//
//  members = [
//    "serviceAccount:${google_service_account.data-developer.email}"
////    "user:CreativeAris99@gmail.com",
//  ]
//  condition {
//    title       = "expires_after_2022_12_31"
//    description = "Expiring at midnight of 2022-12-31"
//    expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
//  }
//}

// todo test again and assign somewhere
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy
//data "google_iam_policy" "admin" {
//  binding {
//    role = "roles/compute.instanceAdmin"
//
//    members = [
//      "serviceAccount:${google_service_account.data-developer.email}"
//    ]
//  }
//
//  binding {
//    role = "roles/storage.objectViewer"
//
//    members = [
//      "user:CreativeAris99@gmail.com",
//    ]
//  }
//
//  //  audit_config {
//  //    service = "cloudkms.googleapis.com"
//  //    audit_log_configs {
//  //      log_type = "DATA_READ",
//  //      exempted_members = ["user:krupnik.yuri@gmail.com"]
//  //    }
//
//  //    audit_log_configs {
//  //      log_type = "DATA_WRITE",
//  //    }
//  //
//  //    audit_log_configs {
//  //      log_type = "ADMIN_READ",
//  //    }
//  //  }
//}


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

//resource "google_service_account_key" "mykey" {
//  service_account_id = google_service_account.bi-developer.name
//}


//data "google_client_config" "default" {
//  provider = google
//}
//data "google_service_account_access_token" "default" {
//  provider               = google
//  target_service_account = "service_B@projectB.iam.gserviceaccount.com"
//  scopes                 = ["userinfo-email", "cloud-platform"]
//  lifetime               = "300s"
//}
//
//provider "google" {
//  alias        = "impersonated"
//  access_token = data.google_service_account_access_token.default.access_token
//}
//
//resource "google_service_account_iam_binding" "token-creator-iam" {
//  service_account_id = "projects/-/serviceAccounts/service_B@projectB.iam.gserviceaccount.com"
//  role               = "roles/iam.serviceAccountTokenCreator"
//  members = [
//    "serviceAccount:service_A@projectA.iam.gserviceaccount.com",
//  ]
//}
