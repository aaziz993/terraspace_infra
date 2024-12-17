# This is where you put your variables declaration
variable "kind" {
  type        = string
  description = "Module kind."
  validation {
    condition = contains([
      "AlertingRule", "RecordingRule", "RulerConfig", "LokiStack",
    ], var.kind)
    error_message = "Must be in 'AlertingRule', 'RecordingRule', 'RulerConfig', 'LokiStack'."
  }
}

variable "metadata" {
  description = "Module metadata."
}

variable "spec" {
  description = "Module specification."
}