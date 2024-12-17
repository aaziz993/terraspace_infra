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
  default     = "istio-operator"
}

variable "hub" {
  type        = string
  description = "Module download hub."
  default     = "gcr.io/istio-release"
}

variable "tag" {
  type        = string
  description = "Module download version tag."
  default     = "1.17.2"
}

variable "revision" {
  type        = string
  description = "Module download version tag."
  default     = ""
}

variable "additional_set" {
  description = "Additional sets to Helm"
  default     = []
}

variable "node_selector" {
  type        = map(string)
  description = "Node selection constraint. You can add the nodeSelector field to your Pod specification and specify the node labels you want the target node to have. Kubernetes only schedules the Pod onto nodes that have each of the labels you specify."
  default     = null
}

variable "replicas" {
  type        = number
  description = "Module replica."
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

variable "watch_namespaces" {
  type        = list(string)
  description = "Watch namespaces for crds manifests."
  default     = ["istio-system"]
}

variable "crds" {
  type = object({
    enabled = bool
  })
  description = "Module crds."
  default     = {
    enabled = false
  }
}
