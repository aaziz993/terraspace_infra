# This is where you put your variables declaration
variable "kind" {
  type        = string
  description = "Module kind."
  validation {
    condition = contains([
      "GrafanaDashboard", "GrafanaDataSource", "GrafanaFolder", "GrafanaNotificationChannel", "Grafana",
    ], var.kind)
    error_message = "Must be in 'GrafanaDashboard', 'GrafanaDataSource', 'GrafanaFolder', 'GrafanaNotificationChannel', 'Grafana'."
  }
}

variable "metadata" {
  description = "Module metadata."
}

variable "spec" {
  description = "Module specification."
}