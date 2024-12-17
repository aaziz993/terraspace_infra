# --------------------------------------------------NETRIS AND ISTIO----------------------------------------------------
network = {
  netris = {
    controller = {
      node_selector = null
      replicas      = 1
      resources     = {
        limits = {
          cpu    = "1000m"
          memory = "2048Mi"
        }
        requests = {
          cpu    = "500m"
          memory = "1024Mi"
        }
      }
      netris = {
        login    = "<%= ENV['NETRIS_LOGIN'] %>"
        password = "<%= ENV['NETRIS_PASSWORD'] %>"
        auth_key = null
      }
      ingress             = null
      web_service_backend = {
        replicas    = 1
        autoscaling = {
          enabled                           = false
          min_replicas                      = 1
          max_replicas                      = 5
          target_cpu_utilization_percentage = 60
        }
      }
      web_service_frontend = {
        replicas = 1
        service  = {
          type        = "NodePort"
          node_port   = 30000
          autoscaling = {
            enabled                           = false
            min_replicas                      = 1
            max_replicas                      = 5
            target_cpu_utilization_percentage = 60
          }
        }
      }
      grpc = {
        replicas    = 1
        autoscaling = {
          enabled                           = false
          min_replicas                      = 1
          max_replicas                      = 5
          target_cpu_utilization_percentage = 60
        }
      }
      telescope = {
        replicas    = 1
        autoscaling = {
          enabled                           = false
          min_replicas                      = 1
          max_replicas                      = 5
          target_cpu_utilization_percentage = 60
        }
      }
      telescope_notifier = {
        replicas    = 1
        autoscaling = {
          enabled                           = false
          min_replicas                      = 1
          max_replicas                      = 5
          target_cpu_utilization_percentage = 60
        }
      }
      web_session_generator = {
        replicas    = 1
        autoscaling = {
          enabled                           = false
          min_replicas                      = 1
          max_replicas                      = 5
          target_cpu_utilization_percentage = 60
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
    operator = {
      node_selector = null
      replicas      = 1
      resources     = {
        limits = {
          cpu    = "1000m"
          memory = "2048Mi"
        }
        requests = {
          cpu    = "500m"
          memory = "1024Mi"
        }
      }
      controller = {
        host     = "<%= ENV['NETRIS_ADDRESS'] %>"
        login    = "<%= ENV['NETRIS_LOGIN'] %>"
        password = "<%= ENV['NETRIS_PASSWORD'] %>"
      }
      log = {
        level = "debug"
      }
    }
  }
  istio = {
    hub      = "gcr.io/istio-release"
    tag      = "1.18.0-beta.0"
    operator = {
      replicas  = 1
      resources = {
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
      replicas    = 1
      autoscaling = {
        enabled                    = false
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
        replicas    = 1
        autoscaling = {
          enabled                    = false
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
        replicas    = 1
        autoscaling = {
          enabled                    = false
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
      replicas    = 1
      autoscaling = {
        enabled                    = false
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
        level = "warning"
      }
    }
  }
}

# --------------------------------CERT-MANAGER, TRUST-MANAGER, SPIRE, VAULT AND KEYCLOAK--------------------------------
security = {
  cert_manager = {
    node_selector = null
    replicas      = 1,
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
    server = {
      log = {
        level = "debug"
      }
    }
    agent = {
      spire_server = {
        address = "spire-server"
        port    = 8081
      }
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
    image         = "vault:1.13.0"
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

# -------------------------------------------------KAFKA AND ZOOKEEPER--------------------------------------------------
messaging = {
  kafka = {

  }
  zookeeper = {

  }
}

# ---------------------------------------------REDIS, HAZELCAST AND POSTGRES--------------------------------------------
storage = {
  redis     = {}
  hazelcast = {}
  postgres  = {}
}

# --------------------------------------JAEGER, LOKI, PROMETHEUS, GRAFANA AND KIALI-------------------------------------
observability = {
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
        enabled_profiler = true
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
      format            = "text"
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

