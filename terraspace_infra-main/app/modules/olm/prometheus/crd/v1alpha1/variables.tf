# This is where you put your variables declaration
variable "kind" {
  type        = string
  description = "Module kind."
  validation {
    condition = contains([
      "AlertmanagerConfig", "PrometheusAgent", "ScrapeConfig",
    ], var.kind)
    error_message = "Must be in 'AlertmanagerConfig', 'PrometheusAgent', 'ScrapeConfig'."
  }
}

variable "metadata" {
  description = "Module metadata."
}

variable "spec" {
  description = "Module specification."
}