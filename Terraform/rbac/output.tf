output "server_application_id" {
  value = "${azuread_application.server.application_id}"
}
output "server_application_object_id" {
  value = "${azuread_application.server.object_id}"
}

output "server_application_secret" {
  value = "${random_string.server.result}"
}
output "server_application_permissions" {
  value = "${azuread_application.server.oauth2_permissions}"
}
output "client_application_id" {
  value = "${azuread_application.client.application_id}"
}
output "client_application_object_id" {
  value = "${azuread_application.client.object_id}"
}
output "client_application_secret" {
  value = "${random_string.client.result}"
}