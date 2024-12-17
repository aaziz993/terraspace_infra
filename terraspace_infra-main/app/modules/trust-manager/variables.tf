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
  default     = "trust-manager"
}

variable "chart_version" {
  type        = string
  description = "Module chart version."
  default     = "0.4.0"
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

variable "crds" {
  type = object({
    enabled = bool
  })
  description = "Module crds."
  default     = {
    enabled = true
  }
}

variable "app" {
  type = object({
    trust = object({
      # Namespace used as trust source. Note that the namespace must exist before installing trust-manager.
      namespace_name = string
    })
    log_level = number
  })
  description = "Trust-manager application configuration."
  default     = {
    trust = {
      namespace_name = "cert-manager"
    }
    log_level = 1
  }
}