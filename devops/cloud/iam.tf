resource "google_service_account" "sage_run" {
  project      = var.project_id
  account_id   = local.sage_run_account_id # <--- CORRETTO (prima era local.service_account_id)
  display_name = "Sage - runtime Cloud Run"

  depends_on = [google_project_service.apis]
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.sage.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}