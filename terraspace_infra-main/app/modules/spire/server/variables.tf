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
  default     = "spire-server"
}

variable "hub" {
  type        = string
  description = "Module hub"
  default     = "gcr.io/spiffe-io/spire-server"
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

variable "trust_bundle" {
  type = object({
    create = bool
    name   = string
  })
  description = "Spire-server trust bundle."
  default     = {
    create = true
    name   = "trust-bundle"
  }
}

variable "bind" {
  type = object({
    address = string
    port    = number
  })
  description = "Spire-server bind address and port."
  default     = {
    address = "0.0.0.0"
    port    = 8081
  }
}

variable "socket_path" {
  type        = string
  description = "Server-server socket path."
  default     = "/run/spire/sockets/server.sock"
}

variable "trust_domain" {
  type        = string
  description = "Spire-server trust domain."
  default     = "cluster.local"
}

variable "log_level" {
  type        = string
  description = "Spire-server log level."
  default     = "debug"
}

variable "ca" {
  type = object({
    ttl      = string
    key_type = string
    subject  = object({
      country      = list(string)
      organization = list(string)
      common_name  = string
    })
  })
  description = "SVID ca."
  default     = {
    ttl      = "24h"
    key_type = "rsa-2048"
    subject  = {
      country      = ["US"]
      organization = ["SPIFFE"]
      common_name  = ""
    }

  }
}

variable "svid_ttl" {
  type        = string
  description = "SVID TTL value."
  default     = "1h"
}

variable "cluster_name" {
  type        = string
  description = "Spire-server cluster name."
  default     = "cluster.local"
}

variable "service_account_allow_list" {
  type        = list(string)
  description = "Allowed acount list."
  default     = ["spire:spire-agent"]
}

variable "plugins" {
  type        = list(string)
  description = "Spire-server plugins."
  default     = []
}

variable "k8s_workload_registrar" {
  type = object({
    hub = string
    tag = string
  })
  description = "Spire-server automatic workload registrar."
  default     = {
    hub = "gcr.io/spiffe-io/k8s-workload-registrar"
    tag = "1.2.0"
  }
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
