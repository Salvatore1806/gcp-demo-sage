resource "google_service_account" "sage_run" {
  project      = var.project_id
  account_id   = local.sage_run_account_id # <--- CORRETTO (prima era local.service_account_id)
  display_name = "Sage - runtime Cloud Run"

  depends_on = [google_project_service.apis]
}

