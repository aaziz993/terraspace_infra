# This is where you put your outputs declaration
output "namespace" {
  value = var.namespace
}

output "name" {
  value = var.name
}

output "login" {
  value = var.netris.login
}

output "password" {
  sensitive = true
  value     = kubernetes_secret.netris-controller.data.password
}

output "auth_key" {
  sensitive = true
  value     = kubernetes_secret.netris-controller.data.auth_key
}