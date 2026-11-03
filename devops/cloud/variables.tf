variable "project_id" {
  description = "ID del progetto Google Cloud."
  type        = string
}

variable "region" {
  description = "Regione Google Cloud per le risorse."
  type        = string
  default     = "europe-west6"
}

variable "resource_prefix" {
  description = "Prefisso per le risorse in un progetto condiviso; vuoto per un progetto dedicato."
  type        = string
  default     = ""
}

variable "app_name" {
  description = "Nome base dell'applicazione."
  type        = string
  default     = "sage"
}

variable "docs_bucket_suffix" {
  description = "Suffisso del bucket dei documenti."
  type        = string
  default     = "sage-docs"
}

variable "firestore_collection" {
  description = "Collection Firestore per i chunk."
  type        = string
  default     = "chunks"
}

variable "embedding_dimension" {
  description = "Dimensione degli embedding."
  type        = number
  default     = 768
}

variable "bq_dataset" {
  description = "Nome base del dataset BigQuery."
  type        = string
  default     = "sage_analytics"
}

variable "bq_table" {
  description = "Nome della tabella BigQuery."
  type        = string
  default     = "question_log"
}