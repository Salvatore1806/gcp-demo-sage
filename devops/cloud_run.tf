# 1. Attivazione delle API GCP necessarie
locals {
  gcp_services = [
    "run.googleapis.com",              # Cloud Run API
    "artifactregistry.googleapis.com", # Artifact Registry API (equivalente GCP di ECR)
    "iam.googleapis.com",              # Identity and Access Management API
    "aiplatform.googleapis.com"        # Vertex AI API (per Gemini)
  ]
}

resource "google_project_service" "enabled_services" {
  for_each           = toset(local.gcp_services)
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

# 2. Container Registry (Artifact Registry)
resource "google_artifact_registry_repository" "repository" {
  project       = var.project_id
  location      = var.region
  repository_id = var.resource_prefix
  description   = "Repository Docker per ${var.resource_prefix}"
  format        = "DOCKER"

  depends_on = [google_project_service.enabled_services]
}

# 3. Service Account con lo stesso nome prefissato
resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = var.resource_prefix
  display_name = "Service Account per ${var.resource_prefix}"

  depends_on = [google_project_service.enabled_services]
}

# 4. Permessi IAM al Service Account per chiamare Vertex AI (Gemini) e leggere immagini
resource "google_project_iam_member" "vertex_ai_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "artifact_registry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

# 5. Servizio Cloud Run v2 (1 vCPU, 2GB RAM)
resource "google_cloud_run_v2_service" "default" {
  name     = var.resource_prefix
  location = var.region
  project  = var.project_id

  template {
    service_account = google_service_account.service_account.email

    containers {
      # Path dell'immagine su Artifact Registry (sostituire 'app:latest' con il tag reale della tua immagine)
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repository.repository_id}/app:latest"

      resources {
        limits = {
          cpu    = "1"
          memory = "2Gi"
        }
      }
    }
  }

  depends_on = [
    google_project_service.enabled_services,
    google_project_iam_member.vertex_ai_user
  ]
}