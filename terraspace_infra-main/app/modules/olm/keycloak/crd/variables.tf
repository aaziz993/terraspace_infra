# This is where you put your variables declaration
variable "kind" {
  type        = string
  description = "Module kind."
  validation {
    condition = contains([
      "Keycloak", "KeycloakRealmImport",
    ], var.kind)
    error_message = "Must be in 'Keycloak' ,'KeycloakRealmImport'."
  }
}

variable "metadata" {
  description = "Module metadata."
}

variable "spec" {
  description = "Module specification."
}