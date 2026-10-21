# Servizio Cloud Run v2 (1 vCPU, 2GB RAM)
resource "google_cloud_run_v2_service" "sage_run" {
  name     = local.app_name
  location = var.region
  project  = var.project_id

  template {
    service_account = google_service_account.sage_run.email

    containers {
      # Path dell'immagine su Artifact Registry
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.sage.repository_id}/app:latest"

      resources {
        limits = {
          cpu    = "1"
          memory = "2Gi"
        }
      }
    }
  }

  depends_on = [
    google_project_service.apis,
    google_project_iam_member.sage_run_vertex
  ]
}