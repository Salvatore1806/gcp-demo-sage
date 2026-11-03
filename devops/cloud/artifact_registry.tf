resource "google_artifact_registry_repository" "sage" {
  project       = var.project_id
  location      = var.region
  repository_id = local.app_name
  description   = "Immagini Docker di Sage"
  format        = "DOCKER"

  depends_on = [google_project_service.apis]
}
