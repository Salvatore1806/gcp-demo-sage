# Servizio Cloud Run v2 (1 vCPU, 2GB RAM)
resource "google_cloud_run_v2_service" "sage" { # <--- CORRETTO: rinominato in "sage" per allinearlo con outputs.tf
  name     = local.app_name
  location = var.region
  project  = var.project_id

  template {
    service_account = google_service_account.sage_run.email

    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      env {
        name  = "SAGE_PROJECT_ID"
        value = var.project_id
      }
      env {
        name  = "SAGE_BQ_DATASET"
        value = var.bq_dataset
      }

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
    google_project_iam_member.sage_run
  ]
  resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.sage.name
  role     = "roles/run.invoker"
  member   = "allUsers"
  }
}