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
  default     = "netris-controller"
}

#variable "chart_version" {
#  type        = string
#  description = "Module version"
#  default     = "1.4.0"
#}

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

variable "netris" {
  type = object({
    login    = string
    password = string
    auth_key = string
  })
  description = "Netris-Controller common parameters."
  default     = {
    login    = "nertis"
    password = "newNet0ps"
    auth_key = "mystrongkey"
  }
}

variable "ingress" {
  type = object({
    enabled = bool
    tls     = optional(list(object({
      secret_name = string
      hosts       = optional(list(string))
    })))
  })
  description = "Netris-Controller ingress resources parameters."
  default     = null
}

variable "web_service_backend" {
  type = object({
    replicas    = number
    autoscaling = optional(object({
      enabled                           = bool
      min_replicas                      = optional(number)
      max_replicas                      = optional(number)
      target_cpu_utilization_percentage = optional(number)
    }))
  })
  description = "Netris-Controller web-service-backend parameters."
  default     = {
    replicas    = 1
    autoscaling = null
  }
}

variable "web_service_frontend" {
  type = object({
    replicas = number
    service  = optional(object({
      type      = optional(string)
      node_port = optional(number)
    }))
    autoscaling = optional(object({
      enabled                           = bool
      min_replicas                      = optional(number)
      max_replicas                      = optional(number)
      target_cpu_utilization_percentage = optional(number)
    }))
  })
  description = "Netris-Controller web-service-frontend parameters."
  default     = {
    replicas    = 1
    service     = null
    autoscaling = null
  }
}

variable "grpc" {
  type = object({
    replicas    = number
    autoscaling = optional(object({
      enabled                           = bool
      min_replicas                      = optional(number)
      max_replicas                      = optional(number)
      target_cpu_utilization_percentage = optional(number)
    }))
  })
  description = "Netris-Controller grpc parameters."
  default     = {
    replicas    = 1
    autoscaling = null
  }
}

variable "telescope" {
  type = object({
    replicas    = number
    autoscaling = optional(object({
      enabled                           = bool
      min_replicas                      = optional(number)
      max_replicas                      = optional(number)
      target_cpu_utilization_percentage = optional(number)
    }))
  })
  description = "Netris-Controller telescope parameters."
  default     = {
    replicas    = 1
    autoscaling = null
  }
}

variable "telescope_notifier" {
  type = object({
    replicas    = number
    autoscaling = optional(object({
      enabled                           = bool
      min_replicas                      = optional(number)
      max_replicas                      = optional(number)
      target_cpu_utilization_percentage = optional(number)
    }))
  })
  description = "Netris-Controller telescope-notifier parameters."
  default     = {
    replicas    = 1
    autoscaling = null
  }
}

variable "web_session_generator" {
  type = object({
    replicas    = number
    autoscaling = optional(object({
      enabled                           = bool
      min_replicas                      = optional(number)
      max_replicas                      = optional(number)
      target_cpu_utilization_percentage = optional(number)
    }))
  })
  description = "Netris-Controller web-session-generator parameters."
  default     = {
    replicas    = 1
    autoscaling = null
  }
}

variable "equinix_metal_agent" {
  type = object({
    enabled = bool
  })
  description = "Netris-Controller equinix-metal-agent parameters."
  default     = {
    enabled = true
  }
}

variable "phoenixnap_bmc_agent" {
  type = object({
    enabled = bool
  })
  description = "Netris-Controller phoenixnap-bmc-agent parameters."
  default     = {
    enabled = true
  }
}

variable "haproxy" {
  type = object({
    enabled = bool
  })
  description = "HAProxy parameters."
  default     = {
    enabled = true
  }
}
