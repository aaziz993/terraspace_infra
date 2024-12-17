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
  default     = "weblate"
}

variable "chart_version" {
  type        = string
  description = "Module chart version."
  default     = "0.4.24"
}

variable "additional_set" {
  description = "Additional sets to Helm"
  default     = []
}

variable "replicas" {
  type        = number
  description = "Module replicas."
  default     = 1
}

variable "resources" {
  type = object({
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
  })
  description = "Module required cpu/memory resources."
  default     = null
}