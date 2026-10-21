# Servizio Cloud Run v2 (1 vCPU, 2GB RAM)
resource "google_cloud_run_v2_service" "sage" { # <--- CORRETTO: rinominato in "sage" per allinearlo con outputs.tf
  name     = local.app_name
  location = var.region
  project  = var.project_id

  template {
    service_account = google_service_account.sage_run.email

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.sage.repository_id}/app:latest"

      resources {
        limits = {
          cpu    = "1"
          memory = "2Gi"
        }
      }
    }
  }

  # Mantiene l'immagine aggiornata dalla pipeline di deploy senza sovrascriverla
  lifecycle {
    ignore_changes = [
      template[0].containers[0].image
    ]
  }

  depends_on = [
    google_project_service.apis,
    google_project_iam_member.sage_run_vertex
  ]
}