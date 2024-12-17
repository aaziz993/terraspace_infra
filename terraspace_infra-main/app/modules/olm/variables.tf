# This is where you put your variables declaration
variable "namespace" {
  type = object({
    create   = optional(bool)
    metadata = object({
      name        = string
      labels      = optional(map(string))
      annotations = optional(map(string))
    })
  })
  description = "Module namespace."
}

variable "name" {
  type        = string
  description = "Module deploy name."
  default     = "olm"
}

variable "chart_version" {
  type        = string
  description = "Module version"
  default     = "v0.24.0"
}

variable "additional_set" {
  description = "Additional sets to Helm"
  default     = []
}
