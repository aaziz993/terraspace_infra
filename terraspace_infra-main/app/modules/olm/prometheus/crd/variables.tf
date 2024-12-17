# This is where you put your variables declaration
variable "kind" {
  type        = string
  description = "Module kind."
  validation {
    condition = contains([
      "Alertmanager", "PodMonitor", "Probe", "Prometheus", "PrometheusRule", "ServiceMonitor", "ThanosRuler",
    ], var.kind)
    error_message = "Must be in 'Alertmanager', 'PodMonitor', 'Probe', 'Prometheus', 'PrometheusRule', 'ServiceMonitor', 'ThanosRuler'."
  }
}

variable "metadata" {
  description = "Module metadata."
}

variable "spec" {
  description = "Module specification."
}