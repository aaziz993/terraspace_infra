# This is where you put your variables declaration

# -------------------------------------------------NETRIS AND ISTIO-----------------------------------------------------
variable "network" {
  type = object({
    netris = object({
      controller = object({
        node_selector = optional(map(string))
        replicas      = number
        resources     = object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        })
        netris = object({
          login    = string
          password = optional(string)
          auth_key = optional(string)
        })
        ingress = optional(object({
          enabled = bool
          tls     = optional(list(object({
            secret_name = string
            hosts       = optional(list(string))
          })))
        }))
        web_service_backend = object({
          replicas    = number
          autoscaling = optional(object({
            enabled                           = bool
            min_replicas                      = optional(number)
            max_replicas                      = optional(number)
            target_cpu_utilization_percentage = optional(number)
          }))
        })
        web_service_frontend = object({
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
        grpc = object({
          replicas    = number
          autoscaling = optional(object({
            enabled                           = bool
            min_replicas                      = optional(number)
            max_replicas                      = optional(number)
            target_cpu_utilization_percentage = optional(number)
          }))
        })
        telescope = object({
          replicas    = number
          autoscaling = optional(object({
            enabled                           = bool
            min_replicas                      = optional(number)
            max_replicas                      = optional(number)
            target_cpu_utilization_percentage = optional(number)
          }))
        })
        telescope_notifier = object({
          replicas    = number
          autoscaling = optional(object({
            enabled                           = bool
            min_replicas                      = optional(number)
            max_replicas                      = optional(number)
            target_cpu_utilization_percentage = optional(number)
          }))
        })
        web_session_generator = object({
          replicas    = number
          autoscaling = optional(object({
            enabled                           = bool
            min_replicas                      = optional(number)
            max_replicas                      = optional(number)
            target_cpu_utilization_percentage = optional(number)
          }))
        })
        equinix_metal_agent = object({
          enabled = bool
        })
        phoenixnap_bmc_agent = object({
          enabled = bool
        })
        haproxy = object({
          enabled = bool
        })
      })
      operator = object({
        node_selector = optional(map(string))
        replicas      = number
        resources     = object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        })
        controller = object({
          host     = string
          login    = string
          password = string
        })
        log = object({
          level = string
        })
      })
    })
    istio = object({
      hub      = string
      tag      = string
      operator = object({
        node_selector = optional(map(string))
        replicas      = number
        resources     = object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        })
      })
      cni = object({
        node_selector = optional(map(string))
        replicas      = number
        autoscaling   = object({
          enabled                    = bool
          min_replicas               = optional(number)
          max_replicas               = optional(number)
          target_average_utilization = optional(number)
        })
        resources = object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        })
        log = object({
          level = string
        })
      })
      pilot = object({
        node_selector = optional(map(string))
        replicas      = number
        autoscaling   = object({
          enabled                    = bool
          min_replicas               = optional(number)
          max_replicas               = optional(number)
          target_average_utilization = optional(number)
        })
        resources = object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        })
        ca = object({
          cert = object({
            duration     = string
            renew_before = optional(string)
            private_key  = object({
              algorithm       = string
              size            = number
              encoding        = string
              rotation_policy = string
            })
            subject = optional(object({
              organizations = optional(list(string))
            }))
            usages    = optional(list(string))
            dns_names = optional(list(string))
          })
        })
        consul = optional(object({
          address = string
          port    = number
        }))
      })
      ingress_gateways = object({
        north_south = object({
          node_selector = optional(map(string))
          replicas      = number
          autoscaling   = object({
            enabled                    = bool
            min_replicas               = optional(number)
            max_replicas               = optional(number)
            target_average_utilization = optional(number)
          })
          resources = object({
            requests = optional(object({
              cpu    = optional(string)
              memory = optional(string)
            }))
            limits = optional(object({
              cpu    = optional(string)
              memory = optional(string)
            }))
          })
          load_balancer_ip = string
          domain           = string
        })
        east_west = object({
          node_selector = optional(map(string))
          replicas      = number
          autoscaling   = object({
            enabled                    = bool
            min_replicas               = optional(number)
            max_replicas               = optional(number)
            target_average_utilization = optional(number)
          })
          resources = object({
            requests = optional(object({
              cpu    = optional(string)
              memory = optional(string)
            }))
            limits = optional(object({
              cpu    = optional(string)
              memory = optional(string)
            }))
          })
          load_balancer_ip = string
          domain           = string
        })
      })
      egress_gateway = object({
        node_selector = optional(map(string))
        replicas      = number
        autoscaling   = object({
          enabled                    = bool
          min_replicas               = optional(number)
          max_replicas               = optional(number)
          target_average_utilization = optional(number)
        })
        resources = object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        })
      })
      sidecar = object({
        resources = object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        })
        log = object({
          level = string
        })
      })
    })
  })
  description = "Netris and Istio."
  default     = {
    netris = {
      operator = {
        node_selector = null
        replicas      = 1
        resources     = {
          limits = {
            cpu    = "100m"
            memory = "128Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
        }
        controller = {
          host     = "localhost"
          login    = "netris"
          password = "newNet0ps"
        }
        log = {
          level = "debug"
        }
      }
      controller = {
        node_selector = null
        replicas      = 1
        resources     = {
          limits = {
            cpu    = "100m"
            memory = "128Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
        }
        netris = {
          login    = "netris"
          password = "newNet0ps"
          auth_key = null
        }
        ingress             = null
        web_service_backend = {
          replicas    = 1
          autoscaling = {
            enabled                           = true
            min_replicas                      = 1
            max_replicas                      = 5
            target_cpu_utilization_percentage = 50
          }
        }
        web_service_frontend = {
          replicas = 1
          service  = {
            type      = "NodePort"
            node_port = 30000
          }
          autoscaling = {
            enabled                           = true
            min_replicas                      = 1
            max_replicas                      = 5
            target_cpu_utilization_percentage = 50
          }
        }
        grpc = {
          replicas    = 1
          autoscaling = {
            enabled                           = true
            min_replicas                      = 1
            max_replicas                      = 5
            target_cpu_utilization_percentage = 50
          }
        }
        telescope = {
          replicas    = 1
          autoscaling = {
            enabled                           = true
            min_replicas                      = 1
            max_replicas                      = 5
            target_cpu_utilization_percentage = 50
          }
        }
        telescope_notifier = {
          replicas    = 1
          autoscaling = {
            enabled                           = true
            min_replicas                      = 1
            max_replicas                      = 5
            target_cpu_utilization_percentage = 50
          }
        }
        web_session_generator = {
          replicas    = 1
          autoscaling = {
            enabled                           = true
            min_replicas                      = 1
            max_replicas                      = 5
            target_cpu_utilization_percentage = 50
          }
        }
        equinix_metal_agent = {
          enabled = true
        }
        phoenixnap_bmc_agent = {
          enabled = true
        }
        haproxy = {
          enabled = false
        }
      }
    }
    istio = {
      hub      = "gcr.io/istio-release"
      tag      = "1.18.0-beta.0"
      operator = {
        node_selector = null
        replicas      = 1
        resources     = {
          limits = {
            cpu    = "200m"
            memory = "256Mi"
          }
          requests = {
            cpu    = "50m"
            memory = "128Mi"
          }
        }
      }
      cni = {
        node_selector = null
        replicas      = 1
        autoscaling   = {
          enabled                    = true
          min_replicas               = 1
          max_replicas               = 5
          target_average_utilization = 60
        }
        resources = {
          limits = {
            cpu    = "400m"
            memory = "400Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "100Mi"
          }
        }
        log = {
          level = "debug"
        }
      }
      pilot = {
        node_selector = null
        replicas      = 1
        autoscaling   = {
          enabled                    = true
          min_replicas               = 1
          max_replicas               = 5
          target_average_utilization = 60
        }
        resources = {
          limits = {
            cpu    = "1000m"
            memory = "4096Mi"
          }
          requests = {
            cpu    = "500m"
            memory = "2048Mi"
          }
        }
        ca = {
          cert = {
            duration     = "87600h" # 10 years
            renew_before = "360h" # 15d
            private_key  = {
              algorithm       = "ECDSA"
              size            = 256
              encoding        = "PKCS1"
              rotation_policy = "Always"
            }
          }
        }
        consul = null
      }
      ingress_gateways = {
        north_south = {
          node_selector = null
          replicas      = 1
          autoscaling   = {
            enabled                    = true
            min_replicas               = 1
            max_replicas               = 5
            target_average_utilization = 60
          }
          resources = {
            limits = {
              cpu    = "2000m"
              memory = "1024Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
          load_balancer_ip = "192.168.0.55"
          domain           = "northsouth.lb"
        }
        east_west = {
          node_selector = null
          replicas      = 1
          autoscaling   = {
            enabled                    = true
            min_replicas               = 1
            max_replicas               = 5
            target_average_utilization = 60
          }
          resources = {
            limits = {
              cpu    = "2000m"
              memory = "1024Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
          load_balancer_ip = "10.0.0.55"
          domain           = "eastwest.lb"
        }
      }
      egress_gateway = {
        node_selector = null
        replicas      = 1
        autoscaling   = {
          enabled                    = true
          min_replicas               = 1
          max_replicas               = 5
          target_average_utilization = 60
        }
        resources = {
          limits = {
            cpu    = "2000m"
            memory = "1024Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
        }
      }
      sidecar = {
        resources = {
          limits = {
            cpu    = "2000m"
            memory = "1024Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
        }
        log = {
          level = "debug"
        }
      }
    }
  }
}

# ----------------------------------CERT-MANAGER, TRUST-MANAGER, SPIRE, VAULT, KEYCLOAK---------------------------------
variable "security" {
  type = object({
    cert_manager = object({
      node_selector = optional(map(string))
      replicas      = number
      resources     = object({
        requests = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
        limits = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
      })
      ca = object({
        issuer = any
        cert   = object({
          duration     = string
          renew_before = optional(string)
          private_key  = optional(object({
            algorithm       = string
            size            = number
            encoding        = string
            rotation_policy = string
          }))
        })
      })
      startupapicheck = object({
        node_selector = optional(map(string))
        resources     = object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        })
      })
      webhook = object({
        node_selector = optional(map(string))
        replicas      = number
        resources     = object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        })
      })
      cainjector = object({
        node_selector = optional(map(string))
        replicas      = number
      })
    })
    trust_manager = object({
      replicas  = number
      resources = object({
        requests = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
        limits = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
      })
      log = object({
        level = number
      })
    })
    spire = object({
      server = object({
        log = object({
          level = string
        })
      })
      agent = object({
        spire_server = object({
          address = string
          port    = number
        })
        log = object({
          level = string
        })
      })
    })
    vault = object({
      operator = object({
        node_selector = optional(map(string))
        replicas      = number
        resources     = object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        })
      })
      image         = string
      node_selector = optional(map(string))
      replicas      = number
      resources     = object({
        requests = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
        limits = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
      })
      log = object({
        level  = string
        format = string
      })
    })
    keycloak = object({
      operator = object({
        node_selector = optional(map(string))
        replicas      = number
        resources     = object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        })
      })
      image         = string
      node_selector = optional(map(string))
      replicas      = number
      resources     = object({
        requests = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
        limits = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
      })
      log = object({
        level = string
      })
    })
  })
  description = "Cert-manager, Trust-manager, Spire Vault and Keycloak."
  default     = {
    cert_manager = {
      node_selector = null
      replicas      = 1
      resources     = {
        requests = {
          cpu    = "10m"
          memory = "32Mi"
        }
        limits = {
          cpu    = "20m"
          memory = "64Mi"
        }
      }
      ca = {
        issuer = {
          selfSigned = {}
        }
        cert = {
          duration     = "87600h" # 10 years
          renew_before = "360h" # 15d
          private_key  = {
            algorithm       = "ECDSA"
            size            = 256
            encoding        = "PKCS1"
            rotation_policy = "Always"
          }
          subject = {
            organizations = ["cert-manager"]
          }
        }
      }
      startupapicheck = {
        node_selector = null
        resources     = {
          requests = {
            cpu    = "10m"
            memory = "32Mi"
          }
          limits = {
            cpu    = "20m"
            memory = "64Mi"
          }
        }
      }
      webhook = {
        node_selector = null
        replicas      = 1
        resources     = {
          requests = {
            cpu    = "10m"
            memory = "32Mi"
          }
          limits = {
            cpu    = "20m"
            memory = "64Mi"
          }
        }
      }
      cainjector = {
        node_selector = null
        replicas      = 1
      }
    }
    trust_manager = {
      replicas  = 1
      resources = {
        limits = {
          cpu    = "100m"
          memory = "128Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }
      }
      log = {
        level = 1
      }
    }
    spire = {
      agent = {
        spire_server = {
          address = "spire-server"
          port    = 8081
        }
        log = {
          level = "debug"
        }
      }
      server = {
        log = {
          level = "debug"
        }
      }
    }
    vault = {
      operator = {
        node_selector = null
        replicas      = 1
        resources     = {
          limits = {
            cpu    = "100m"
            memory = "256Mi"
          }
          requests = {
            cpu = "100m"
            memory : "128Mi"
          }
        }
      }
      image         = "vault:1.13.3"
      node_selector = null
      replicas      = 1
      resources     = {
        vault = {
          limits = {
            cpu    = "200m"
            memory = "512Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "256Mi"
          }
        }
      }
      log = {
        level  = "debug"
        format = "json"
      }
    }
    keycloak = {
      operator = {
        node_selector = null
        replicas      = 1
        resources     = {
          limits = {
            cpu    = "100m"
            memory = "128Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
        }
      }
      image         = "keycloak:21.1.1"
      node_selector = null
      replicas      = 1
      resources     = {
        requests = {
          cpu    = "500m"
          memory = "1024Mi"
        }
        limits = {
          cpu    = "500m"
          memory = "1024Mi"
        }
      }
      log = {
        level = "debug"
      }
    }
  }
}

# -------------------------------------------------KAFKA AND ZOOKEEPER--------------------------------------------------
variable "messaging" {
  type = object({
    kafka = object({

    })
    zookeeper = object({

    })
  })
  description = "Messaging stack - Kafka and Zookeeper."
  default     = {
    kafka = {

    }
    zookeeper = {

    }
  }
}

# --------------------------------------------REDIS, HAZELCAST AND POSTGRES---------------------------------------------
variable "storage" {
  type = object({
    redis     = object({})
    hazelcast = object({})
    postgres  = object({})
  })
  description = "Redis, Hazelcast and Postgresql."
  default     = {
    redis     = {}
    hazelcast = {}
    postgres  = {}
  }
}

# --------------------------------------JAEGER, LOKI, PROMETHEUS, GRAFANA AND KIALI-------------------------------------
variable "observability" {
  type = object({
    kiali = object({
      operator = object({
        node_selector = optional(map(string))
        replicas      = number
        resources     = object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        })
        debug = object({
          enabled          = bool
          verbosity        = optional(string)
          enabled_profiler = optional(bool)
        })
      })
      node_selector = optional(map(string))
      replicas      = number
      autoscaling   = optional(object({
        enabled                           = bool
        min_replicas                      = optional(number)
        max_replicas                      = optional(number)
        target_cpu_utilization_percentage = optional(number)
      }))
      log = object({
        # Supported values are "text" and "json".
        format            = string
        # Supported values are "trace", "debug", "info", "warn", "error" and "fatal"
        level             = string
        sampler_rate      = string
        time_field_format = string
      })
      # Audit logs are emitted each time a user creates, updates or deletes a resource through Kiali.
      audit_log = bool
    })
    prometheus = object({
      operator = object({
        node_selector = optional(map(string))
        replicas      = number
        resources     = optional( object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        }))
        log = object({
          level  = string
          format = string
        })
      })
      node_selector = optional(map(string))
      replicas      = number
      resources     = optional( object({
        requests = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
        limits = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
      }))
      log = object({
        level  = string
        format = string
      })
    })
    grafana = object({
      operator = object({
        node_selector = optional(map(string))
        replicas      = number
        resources     = optional( object({
          requests = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
          limits = optional(object({
            cpu    = optional(string)
            memory = optional(string)
          }))
        }))
        zap = object({
          devel            = bool
          encoder          = string
          level            = string
          sample           = string
          stacktrace_level = string
          time_encoding    = string
        })
      })
      node_selector = optional(map(string))
      replicas      = number
      resources     = optional( object({
        requests = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
        limits = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
      }))
      log = object({
        level = string
        mode  = string
      })
    })
    jaeger = object({
      node_selector = optional(map(string))
      resources     = optional( object({
        requests = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
        limits = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }))
      }))
      log = object({
        level = string
      })
    })
    loki = object({})
  })
  description = "Prometheus, Grafana and Jaeger monitoring stack."
  default     = {
    kiali = {
      operator = {
        node_selector = null
        replicas      = 1
        resources     = {
          limits = {
            cpu    = "40m"
            memory = "256Mi"
          }
          requests = {
            cpu    = "20m"
            memory = "128Mi"
          }
        }
        debug = {
          enabled          = true
          verbosity        = "1"
          enabled_profiler = false
        }
      }
      node_selector = null
      replicas      = 1
      autoscaling   = {
        enabled                           = false
        min_replicas                      = 1
        max_replicas                      = 2
        target_cpu_utilization_percentage = 80
      }
      log = {
        format            = "json"
        level             = "debug"
        sampler_rate      = "1"
        time_field_format = "2006-01-02T15:04:05Z07:00"
      }
      audit_log = true
    }
    prometheus = {
      operator = {
        node_selector = null
        replicas      = 1
        resources     = {
          limits = {
            cpu    = "200m"
            memory = "100Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "50Mi"
          }
        }
        log = {
          level  = "debug"
          format = "logfmt"
        }
      }
      node_selector = null
      replicas      = 1
      resources     = {
        limits = {
          cpu    = "200m"
          memory = "100Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "50Mi"
        }
      }
      log = {
        level  = "debug"
        format = "logfmt"
      }
    }
    grafana = {
      operator = {
        node_selector = null
        replicas      = 1
        resources     = {
          limits = {
            cpu    = "100m"
            memory = "128Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
        }
        zap = {
          devel            = false
          encoder          = "json"
          level            = "debug"
          sample           = ""
          stacktrace_level = "error"
          time_encoding    = "iso8601"
        }
      }
      node_selector = null
      replicas      = 1
      resources     = {
        limits = {
          cpu    = "500m"
          memory = "1Gi"
        }
        requests = {
          cpu    = "250m"
          memory = "256Mi"
        }
      }
      log = {
        level = "warn"
        mode  = "console"
      }
    }
    jaeger = {
      node_selector = null
      resources     = {
        limits = {
          cpu    = "100m"
          memory = "128Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }
      }
      log = {
        level = "debug"
      }
    }
    loki = {}
  }
}