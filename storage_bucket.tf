/*
resource "google_storage_bucket" "default" {
  name          = "backendbucket-tfstate"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}
*/