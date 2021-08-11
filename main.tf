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
//  credentials = "terraform-sa-key.json"
//    credentials = ${{ secrets.GKE_SA_KEY }}
//    credentials =
//  access_token = "ya29.a0ARrdaM-6VLBtr2FmB3m1KZHIsl46NifvOvyNkjyrl_K7Y-gi-FLMpwNtNSp7MeRgHn_-xpi832NNUbsSrmQ8P5lTKhRobPjDpbYSeJjWIIw2qod5cBm4DSng6sY8_qnRyMQcim7E9LsPjqNHibcoU49n8yxT_oNXEihA_hs"

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

output "iden" {
  value = var.identity
}
output "dam" {
  value = module.tf-module-example.dam
}
output "dama" {
  value = module.tf-module-example.storage
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

// STORAGE TESTs

//resource "google_service_account" "storage-admin" {
//  account_id   = "sa-storage-admin"
//  display_name = "My storage admin service account"
//}
//
//resource "google_project_iam_binding" "storage-admin-binding" {
//  role    = "roles/storage.admin"
//  members = [
//    "serviceAccount:${google_service_account.storage-admin.email}"
//  ]
//}
module "tf-module-example" {
  source = "./tf-module-example"
}
// STORAGE TEST end


resource "google_service_account" "sa-general-account" {
  account_id   = "sa-general-sa"
  display_name = "My general service account"
}

resource "google_service_account" "data-developer" {
  account_id   = "sa-data-developer"
  display_name = "My data developer service account"
}

resource "google_service_account" "bi-developer" {
  account_id   = "sa-bi-developer"
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
    "serviceAccount:${google_service_account.sa-general-account.email}",
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
