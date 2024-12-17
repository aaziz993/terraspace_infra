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
  default     = "istio-csr"
}

variable "chart_version" {
  type        = string
  description = "Module version."
  default     = "0.6.0"
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

variable "replica" {
  type        = number
  description = "Istio-csr replica count."
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
  description = "Istio-csr required cpu/memory resources."
  default     = {}
}

variable "app" {
  type = object({
    cert_manager = object({
      namespace_name = string
      issuer         = object({
        group = string
        kind  = string
        name  = string
      })
    })
    controller = object({
      leader_election_namespace_name = string
    })
    istio = object({
      namespace_name = string
    })
    tls = object({
      trust_domain          = string
      certificate_dns_names = list(string)
      root_ca               = object({
        file   = string
        volume = object({
          name        = string
          mount_path  = string
          secret_name = string
        })
      })
    })
  })
  description = "Cert-manager issuer parameters object"
  default     = {
    cert_manager = {
      namespace_name = "istio-system"
      issuer         = {
        group = "cert-manager.io"
        kind  = "Issuer"
        name  = "istio-ca"
      }
    }
    istio = {
      namespace_name = "istio-system"
    }
    tls = {
      trust_domain          = "cluster.local"
      certificate_dns_names = ["cert-manager-istio-csr.cert-manager.svc"]
      root_ca               = {
        file   = "/var/run/secrets/istio-csr/ca.pem"
        volume = {
          name        = "root-ca"
          mount_path  = "/var/run/secrets/istio-csr"
          secret_name = "istio-root-ca"
        }
      }
    }
    controller = {
      leader_election_namespace_name = "istio-system"
    }
  }
}