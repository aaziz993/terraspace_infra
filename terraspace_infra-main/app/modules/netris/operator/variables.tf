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
  default     = "netris-operator"
}

variable "chart_version" {
  type        = string
  description = "Module version"
  default     = "1.1.1"
}

variable "additional_set" {
  description = "Additional sets to module"
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

variable "controller" {
  type = object({
    host     = string
    login    = string
    password = string
    insecure = optional(bool)
  })
  description = "Netris-operator connection new credentials to netris-controller."
  default     = {
    host     = ""
    login    = ""
    password = ""
    insecure = false
  }
}

variable "controller_creds" {
  type = object({
    host = object({
      secret_name = string
      key         = string
    })
    login = object({
      secret_name = string
      key         = string
    })
    password = object({
      secret_name = string
      key         = string
    })
  })
  description = "Netris-operator connection existing credentials to netris-controller."
  default     = {
    host = {
      secret_name = "netris-creds"
      key         = "host"
    }
    login = {
      secret_name = "netris-creds"
      key         = "login"
    }
    password = {
      secret_name = "netris-creds"
      key         = "password"
    }
  }
}

variable "log_level" {
  type        = string
  description = "Netris-operator log level. Allowed values: info or debug."
  default     = "info"
}

variable "requeue_interval" {
  type        = number
  description = "Requeue interval in seconds for the netris-operator."
  default     = 15
}

variable "calico_asn_range" {
  type        = string
  description = "Set Nodes ASN range. Used when Netris-Operator manages Calico CNI."
  default     = "4230000000-4239999999"
}

variable "l4lb_tenant" {
  type        = string
  description = "Set the default Tenant for L4LB resources. If set, a tenant autodetection for L4LB resources will be disabled."
  default     = ""
}
