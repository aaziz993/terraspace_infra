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
  description = "Module name."
  default     = "spire-agent"
}

variable "hub" {
  type        = string
  description = "Module hub"
  default     = "gcr.io/spiffe-io/spire-agent"
}

variable "tag" {
  type        = string
  description = "Module version"
  default     = "1.2.0"
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
  default     = {}
}

variable "csi_driver" {
  type = object({
    enabled    = optional(bool)
    hub        = string
    tag        = string
    mount_path = string
  })
  description = "Spire spiffe csi driver."
  default     = {
    enabled    = true
    hub        = "ghcr.io/spiffe/spiffe-csi-driver"
    tag        = "0.2.0"
    mount_path = "/var/snap/microk8s/common/var/lib/kubelet/pods"
  }
}

variable "socket_path" {
  type        = string
  description = "Server-agent socket path."
  default     = "/run/secrets/workload-spiffe-uds/socket"
}

variable "trust_bundle" {
  type = object({
    create = bool
    name   = string
  })
  description = "Spire-agent trust bundle."
  default     = {
    create = true
    name   = "trust-bundle"
  }
}

variable "trust_domain" {
  type        = string
  description = "Spire-agent trust domain."
  default     = "cluster.local"
}

variable "log_level" {
  type        = string
  description = "Spire-agent log level."
  default     = "debug"
}

variable "spire_server" {
  type = object({
    address = string
    port    = number
  })
  description = "Spire-agent server connection."
  default     = {
    address = "spire-server"
    port    = 8081
  }
}

variable "cluster_name" {
  type        = string
  description = "Spire-agent cluster name."
  default     = "cluster.local"
}

variable "plugins" {
  type        = list(string)
  description = "Spire-agent plugins."
  default     = []
}

variable "crds" {
  type = object({
    enabled = bool
  })
  description = "Spire crds."
  default     = {
    enabled = true
  }
}