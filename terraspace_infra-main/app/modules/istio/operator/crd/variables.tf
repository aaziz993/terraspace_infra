# This is where you put your variables declaration
variable "kind" {
  type        = string
  description = "Module kind."
  validation {
    condition = contains([
      "DestinationRule", "Gateway", "ServiceEntry", "VirtualService",
    ], var.kind)
    error_message = "Must be in 'DestinationRule', 'Gateway', 'ServiceEntry', 'VirtualService'."
  }
}

variable "metadata" {
  description = "Module metadata."
}

variable "spec" {
  description = "Module specification."
}