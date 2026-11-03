resource "google_service_account" "sage_run" {
  project      = var.project_id
  account_id   = local.sage_run_account_id # <--- CORRETTO (prima era local.service_account_id)
  display_name = "Sage - runtime Cloud Run"

  depends_on = [google_project_service.apis]
}

# Permesso di chiamare Vertex AI (modelli Gemini).
resource "google_project_iam_member" "sage_run_vertex" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.sage_run.email}"
}