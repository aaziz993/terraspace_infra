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

variable "chart_version" {
  type        = string
  description = "Module version"
  default     = "1.19.0"
}

variable "name" {
  type        = string
  description = "Module deploy name."
  default     = "kiali-operator"
}

variable "additional_set" {
  description = "Additional sets to Helm"
  default     = []
}

variable "affinity" {
  type        = any
  description = "Node affinity constraint. You can add the affinity field to your Pod specification and specify the node labels you want the target node to have. Kubernetes only schedules the Pod onto nodes that have each of the labels you specify."
  default     = null
}

variable "tolerations" {
  type        = any
  description = "Node tolerations constraint. You can add the tolerations field to your Pod specification and specify the node labels you want the target node to have. Kubernetes only schedules the Pod onto nodes that have each of the labels you specify."
  default     = null
}

variable "node_selector" {
  type        = map(string)
  description = "Node selection constraint. You can add the nodeSelector field to your Pod specification and specify the node labels you want the target node to have. Kubernetes only schedules the Pod onto nodes that have each of the labels you specify."
  default     = null
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

variable "crd_annotations" {
  type        = map(string)
  description = "Annotations for the Vault CRD."
  default     = null
}

variable "watch_namespaces" {
  type        = list(string)
  description = "Watch namespaces for crds manifests."
  default     = [""]
}

variable "sync_period" {
  type        = string
  description = "Sync period for crds manifests."
  default     = "1m"
}

variable "psp" {
  type = object({
    enabled  = bool
    vault_sa = string # Used service account for vault.
  })
  description = "PSP resources."
  default     = {
    enabled  = false
    vault_sa = "vault"
  }
}