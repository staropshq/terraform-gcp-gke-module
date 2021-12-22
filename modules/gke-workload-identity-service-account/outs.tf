output "service_account_id" {
  description = "The ID of the SA"
  value = google_service_account.a.id
}
output "service_account_email" {
  description = "The email of the SA"
  value = google_service_account.a.email
}
output "service_account_name" {
  description = "The name of the SA"
  value = google_service_account.a.name
}
output "service_account_unique_id" {
  description = "The unique ID of the SA"
  value = google_service_account.a.unique_id
}