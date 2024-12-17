# This is where you put your resource declaration

# ---------------------------------------------NAMESPACES---------------------------------------------------------------
# Creating namespace with the Kubernetes provider is better than auto-creation in the helm_release.
# You can reuse the namespace and customize it with quotas and labels.

# Operator lifecycle manager namespace
resource "kubernetes_namespace" "olm" {
  metadata {
    name   = "olm"
    labels = {
      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = "latest"
      "pod-security.kubernetes.io/audit"           = "restricted"
      "pod-security.kubernetes.io/audit-version"   = "latest"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/warn-version"    = "latest"
    }
  }
}

# Operator lifecycle manager global operators namespace
resource "kubernetes_namespace" "global-operators" {
  metadata {
    name   = "operators"
    labels = {
      "pod-security.kubernetes.io/enforce"         = "baseline"
      "pod-security.kubernetes.io/enforce-version" = "latest"
      "pod-security.kubernetes.io/audit"           = "restricted"
      "pod-security.kubernetes.io/audit-version"   = "latest"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/warn-version"    = "latest"
    }
  }
}

# Netris and Istio namespace
resource "kubernetes_namespace" "network" {
  metadata {
    name   = "network"
    labels = {
      netris-operator        = "controller-manager"
      istio-operator-managed = "Reconcile"
      istio-injection        = "disabled"
    }
  }
}

# Cert-manager, Trust-manager, Vault, Keycloak namespace
resource "kubernetes_namespace" "security" {
  metadata {
    name   = "security"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

# Kafka and Zookeeper namespace
resource "kubernetes_namespace" "messaging" {
  metadata {
    name   = "messaging"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

# Redis, Hazelcast and Postgresql namespace
resource "kubernetes_namespace" "storage" {
  metadata {
    name   = "storage"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

# Jaeger, Loki, Prometheus, Grafana and Kiali namespace
resource "kubernetes_namespace" "observability" {
  metadata {
    name   = "observability"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

# Applications namespace
resource "kubernetes_namespace" "compute" {
  metadata {
    name   = "compute"
    labels = {
      "istio.io/dataplane-mode" = "ambient"
    }
  }
}

# Default namespace labels
resource "kubernetes_labels" "default-namespace" {
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = "default"
  }
  labels = {
    "istio.io/dataplane-mode" = "ambient"
  }
}


## ----------------------------------------------MODULES-----------------------------------------------------------------
#
## CERT-MANAGER
#module "cert-manager" {
#  source    = "../../modules/cert-manager"
#  namespace = {
#    create = false
#    name   = kubernetes_namespace.cert-manager.metadata.0.name
#  }
#  node_selector   = var.security.cert_manager.node_selector
#  replicas        = var.security.cert_manager.replicas
#  resources       = var.security.cert_manager.resources
#  startupapicheck = var.security.cert_manager.startupapicheck
#  webhook         = var.security.cert_manager.webhook
#  cainjector      = var.security.cert_manager.cainjector
#  depends_on      = [kubernetes_namespace.cert-manager]
#}


#
#module "istio-operator" {
#  source    = "../../modules/istio/operator"
#  hub       = var.istio.hub
#  tag       = var.istio.tag
#  namespace = {
#    create = false
#    name   = kubernetes_namespace.proxy.metadata.0.name
#  }
#  node_selector    = var.istio.operator.node_selector
#  replicas         = var.istio.operator.replicas
#  resources        = var.istio.operator.resources
#  watch_namespaces = [kubernetes_namespace.proxy.metadata.0.name]
#  depends_on       = [
#    kubernetes_namespace.proxy
#  ]
#}
#
## ISTIO




#module "keycloak-operator" {
#  source    = "../../modules/keycloak/operator"
#  namespace = {
#    create = false
#    name   = kubernetes_namespace.security.metadata.0.name
#  }
#  name          = "keycloak-operator"
#  node_selector = var.security.keycloak.operator.node_selector
#  replicas      = var.security.keycloak.operator.replicas
#  resources     = var.security.keycloak.operator.resources
#  depends_on    = [
#    kubernetes_namespace.security,
#  ]
#}
#
#module "keycloak" {
#  source    = "../../modules/keycloak/operator/keycloak"
#  namespace = {
#    create = false
#    name   = module.keycloak-operator.namespace.name
#  }
#  name = "keycloak"
#  spec = {
#    instances = var.security.keycloak.replicas
#    #    db = {
#    #      database = "database"
#    #      host = "host"
#    #      passwordSecret = {
#    #        key = "passwordSecretKey"
#    #        name = "passwordSecret"
#    #      }
#    #      poolInitialSize = 1
#    #      poolMaxSize = 3
#    #      poolMinSize = 2
#    #      port = 123
#    #      schema = "schema"
#    #      usernameSecret = {
#    #        key = "usernameSecretKey"
#    #        name = "usernameSecret"
#    #      }
#    #      vendor = "postgres"
#    #    }
#    http      = {
#      httpEnabled = true
#      httpPort    = 8180
#    }
#    hostname = {
#      strict            = false
#      strictBackchannel = false
#      adminUrl          = "http:localhost:8081/keycloak"
#    }
#    transaction = {
#      xaEnabled = false
#    }
#    unsupported = {
#      podTemplate = {
#        metadata = {
#          labels = {
#            "istio.io/dataplane-mode" = "ambient"
#          }
#        }
#        spec = {
#          containers = [
#            {
#              args = [
#                "start",
#                "--optimized",
#                "hostname-strict-https=false",
#              ]
#              name = "keycloak"
#            },
#          ]
#        }
#      }
#    }
#    ingress = {
#      enabled = false
#    }
#  }
#  depends_on = [
#    module.keycloak-operator,
#  ]
#}
#








#module "kiali-operator" {
#  source    = "../../modules/kiali/operator"
#  namespace = {
#    create = false
#    name   = kubernetes_namespace.observability.metadata.0.name
#  }
#  name             = "kiali-operator"
#  node_selector    = var.observability.kiali.operator.node_selector
#  replicas         = var.observability.kiali.operator.replicas
#  resources        = var.observability.kiali.operator.resources
#  debug            = var.observability.kiali.operator.debug
#  watch_namespaces = [kubernetes_namespace.observability.metadata.0.name]
#  depends_on       = [
#    kubernetes_namespace.observability,
#    module.istio,
#  ]
#}

#module "prometheus-operator" {
#  source    = "../../modules/prometheus/operator"
#  namespace = {
#    create = false
#    name   = kubernetes_namespace.observability.metadata.0.name
#  }
#  name           = "prometheus-operator"
#  cluster_domain = local.kube.cluster_name
#  operator       = merge(var.observability.prometheus.operator, {
#    enabled          = true
#    watch_namespaces = [kubernetes_namespace.observability.metadata.0.name]
#  })
#  depends_on = [
#    kubernetes_namespace.observability
#  ]
#}
#
#module "prometheus" {
#  source    = "../../modules/prometheus/operator/prometheus"
#  namespace = {
#    create = false
#    name   = module.prometheus-operator.namespace.name
#  }
#  name = "prometheus"
#  spec = {
#    nodeSelector   = var.observability.prometheus.node_selector
#    replicas       = var.observability.prometheus.replicas
#    resources      = var.observability.prometheus.resources
#    externalURL    = "http://localhost:9090/prometheus/"
#    routePrefix    = "/prometheus"
#    externalLabels = {
#      cluster = local.kube.cluster_name
#    }
#    logLevel  = var.observability.prometheus.log.level
#    logFormat = var.observability.prometheus.log.format
#  }
#  depends_on = [
#    module.prometheus-operator,
#  ]
#}
#

#
##module "prometheus-destination-rule" {
##  source    = "../../modules/istio/destination-rule"
##  namespace = {
##    create = false
##    name   = module.istio-operator.namespace.name
##  }
##  name = "prometheus"
##  spec = {
##    host          = "prometheus-operated.${kubernetes_namespace.observability.metadata.0.name}.svc.cluster.local"
##    trafficPolicy = {
##      tls = {
##        mode = "DISABLE"
##      }
##    }
##  }
##  depends_on = [
##    module.prometheus
##  ]
##}
#
#module "grafana-operator" {
#  source    = "../../modules/grafana/operator"
#  namespace = {
#    create = false
#    name   = kubernetes_namespace.observability.metadata.0.name
#  }
#  name           = "grafana-operator"
#  cluster_domain = local.kube.cluster_name
#  operator       = merge(var.observability.grafana.operator, {
#    enabled             = true
#    watch_namespaces    = [kubernetes_namespace.observability.metadata.0.name]
#    scan_all_namespaces = false
#    scan_namespaces     = [kubernetes_namespace.observability.metadata.0.name]
#  })
#  depends_on = [
#    kubernetes_namespace.observability
#  ]
#}
#
#module "grafana" {
#  source    = "../../modules/grafana/operator/grafana"
#  namespace = {
#    create = false
#    name   = module.grafana-operator.namespace.name
#  }
#  name = "grafana"
#  spec = {
#    deployment = {
#      nodeSelector = var.observability.grafana.node_selector
#      replicas     = var.observability.grafana.replicas
#    }
#    resources = var.observability.grafana.resources
#    config    = {
#      server = {
#        domain              = "localhost"
#        root_url            = "http://localhost:3000/grafana/"
#        serve_from_sub_path = true
#      }
#      auth = {
#        anonymous = {
#          enabled = true
#        }
#      }
#      security = {
#        admin_user     = "admin"
#        admin_password = "Admin1234"
#      }
#      log = var.observability.grafana.log
#    }
#    dashboardLabelSelector = [
#      {
#        matchExpressions = [
#          {
#            key      = "app"
#            operator = "In"
#            values   = [
#              "grafana-dashboard",
#            ]
#          },
#        ]
#      },
#    ]
#  }
#  depends_on = [
#    module.grafana-operator,
#  ]
#}



# --------------------------------------------------------OLM-----------------------------------------------------------
module "olm" {
  source = "../../modules/olm"

  namespace = {
    create   = false
    metadata = {
      name = kubernetes_namespace.olm.metadata.0.name
    }
  }

  name = "olm"

  depends_on = [
    kubernetes_namespace.olm,
  ]
}


# Global operator group
module "global-operator-group" {
  source = "../../modules/olm/crd"

  kind = "OperatorGroup"

  metadata = {
    namespace = kubernetes_namespace.global-operators.metadata.0.name
    name      = "global-operatorgroup"
  }

  spec = null

  depends_on = [
    module.olm,
    kubernetes_namespace.global-operators,
  ]
}

# OLM operator group
module "olm-operator-group" {
  source = "../../modules/olm/crd"

  kind = "OperatorGroup"

  metadata = {
    namespace = kubernetes_namespace.olm.metadata.0.name
    name      = "olm-operatorgroup"
  }

  spec = {
    targetNamespaces = [
      kubernetes_namespace.olm.metadata.0.name,
    ]
  }

  depends_on = [
    module.olm,
    kubernetes_namespace.olm,
  ]
}

# Network operator group
module "network-operator-group" {
  source = "../../modules/olm/crd"

  kind = "OperatorGroup"

  metadata = {
    namespace = kubernetes_namespace.network.metadata.0.name
    name      = "operatorgroup"
  }

  spec = {
    targetNamespaces = [
      kubernetes_namespace.network.metadata.0.name,
    ]
  }

  depends_on = [
    module.olm,
    kubernetes_namespace.network,
  ]
}

# Security operator group
module "security-operator-group" {
  source = "../../modules/olm/crd"

  kind = "OperatorGroup"

  metadata = {
    namespace = kubernetes_namespace.security.metadata.0.name
    name      = "operatorgroup"
  }

  spec = {
    targetNamespaces = [
      kubernetes_namespace.security.metadata.0.name,
    ]
  }

  depends_on = [
    module.olm,
    kubernetes_namespace.security,
  ]
}

# Storage operator group
module "storage-operator-group" {
  source = "../../modules/olm/crd"

  kind = "OperatorGroup"

  metadata = {
    namespace = kubernetes_namespace.storage.metadata.0.name
    name      = "operatorgroup"
  }

  spec = {
    targetNamespaces = [
      kubernetes_namespace.storage.metadata.0.name,
    ]
  }

  depends_on = [
    module.olm,
    kubernetes_namespace.storage,
  ]
}

# Observability operator group
module "observability-operator-group" {
  source = "../../modules/olm/crd"

  kind = "OperatorGroup"

  metadata = {
    namespace = kubernetes_namespace.observability.metadata.0.name
    name      = "operatorgroup"
  }

  spec = {
    targetNamespaces = [
      kubernetes_namespace.observability.metadata.0.name,
    ]
  }

  depends_on = [
    module.olm,
    kubernetes_namespace.observability,
  ]
}

# Compute operator group
module "compute-operator-group" {
  source = "../../modules/olm/crd"

  kind = "OperatorGroup"

  metadata = {
    namespace = kubernetes_namespace.compute.metadata.0.name
    name      = "operatorgroup"
  }

  spec = {
    targetNamespaces = [
      kubernetes_namespace.compute.metadata.0.name,
    ]
  }

  depends_on = [
    module.olm,
    kubernetes_namespace.compute,
  ]
}

# ---------------------------------------------------CERT-MANAGER-------------------------------------------------------

#name
#image
#imagePulllPolicy
#nodeSelector
#affinity
#tolerations
#replicas
#hpa
#resources
#port
#log
module "cert-manager-operator" {
  source = "../../modules/olm/crd/v1alpha1"

  kind = "Subscription"

  metadata = {
    namespace = module.global-operator-group.metadata.namespace
    name      = "cert-manager-operator"
  }

  spec = {
    channel         = "stable"
    name            = "cert-manager"
    source          = "operatorhubio-catalog"
    sourceNamespace = module.olm.namespace.metadata.name
    config          = {
      affinity     = var.security.cert_manager.operator.affinity
      nodeSelector = var.security.cert_manager.operator.node_selector
      selector     = var.security.cert_manager.operator.selector
      tolerations  = var.security.cert_manager.operator.tolerations
      resources    = var.security.cert_manager.operator.resources
    }
    env = [
      {
        name  = "ARGS"
        value = "-v=10"
      },
    ]
  }

  depends_on = [
    module.global-operator-group,
  ]
}

module "cert-manager-ca-issuer" {
  source = "../../modules/olm/cert-manager/crd"

  kind = "Issuer"

  metadata = {
    namespace = kubernetes_namespace.security.metadata.0.name
    name      = "${local.env}-cert-manager-ca-issuer"
  }

  spec = var.security.cert_manager.ca.issuer



  depends_on = [
    kubernetes_namespace.security,
    module.cert-manager-operator,
  ]
}

module "cert-manager-ca-cert" {
  source = "../../modules/olm/cert-manager/crd"

  kind = "Certificate"

  metadata = {
    namespace = module.cert-manager-ca-issuer.metadata.namespace
    name      = "${local.env}-cert-manager-ca-cert"
  }

  spec = {
    isCa        = true
    duration    = var.security.cert_manager.ca.cert.duration
    renewBefore = var.security.cert_manager.ca.cert.renew_before
    secretName  = "${local.env}-cert-manager-ca-cert"
    commonName  = "${local.env}-cert-manager-ca-cert"
    privateKey  = var.security.cert_manager.ca.cert.private_key
    subject     = {
      organizations = [
        "cert-manager",
      ]
    }
    issuerRef = {
      kind  = module.cert-manager-ca-issuer.kind
      name  = module.cert-manager-ca-issuer.metadata.name
      group = "cert-manager.io"
    }
  }

  depends_on = [
    module.cert-manager-ca-issuer,
  ]
}

module "ca-issuer" {
  source = "../../modules/olm/cert-manager/crd"

  kind = "ClusterIssuer"

  metadata = {
    namespace = module.cert-manager-ca-cert.metadata.namespace
    name      = "${local.env}-ca-issuer"
  }

  spec = {
    ca = {
      secretName = module.cert-manager-ca-cert.spec.secretName
    }
  }

  depends_on = [
    module.cert-manager-ca-cert,
  ]
}
#
## --------------------------------------------------TRUST-MANAGER------------------------------------------------------
#module "trust-manager" {
#  source    = "../../modules/trust-manager"
#  namespace = {
#    create = false
#    name   = module.cert-manager.namespace.name
#  }
#  name      = "trust-manager"
#  replicas  = var.trust_manager.replicas
#  resources = var.trust_manager.resources
#  app       = {
#    trust = {
#      namespace_name = module.cert-manager.namespace.name
#    }
#    log_level = var.trust_manager.log.level
#  }
#  depends_on = [
#    module.cert-manager-operator,
#  ]
#}
#
#module "cert-manager-ca-cert-trust-bundle" {
#  source = "../../modules/trust-manager/bundle"
#
#  kind = "Bundle"
#
#  metadata = {
#    name = module.cert-manager-ca-cert.metadata.namespace
#    name = "${module.cert-manager-ca-cert.spec.secretName}-trust-bundle"
#  }
#
#  spec = {
#    sources = [
#      {
#        # Include a bundle of publicly trusted certificates which can be
#        # used to validate most TLS certificates on the internet, such as
#        # those issued by Let's Encrypt, Google, Amazon and others.
#        useDefaultCAs = true
#      },
#      {
#        # A Secret in the trust-manager namespace
#        secret = {
#          name = module.cert-manager-ca-cert.spec.secretName
#          key  = "tls.crt"
#        }
#      }
#    ]
#    target = {
#      configMap : {
#        key : "${module.cert-manager-ca-cert.spec.secretName}-trust-bundle.pem"
#      }
#      namespace_selector = {
#        match_labels = {
#          "${module.cert-manager-ca-cert.spec.secretName}-trust-bundle" = "enabled"
#        }
#      }
#    }
#  }
#
#  depends_on = [
#    module.cert-manager-ca-cert, module.trust-manager,
#  ]
#}
#

## ------------------------------------------------------NETRIS----------------------------------------------------------
#module "netris-controller" {
#  source    = "../../modules/netris/controller"
#  namespace = {
#    create = false
#    name   = kubernetes_namespace.vpc.metadata.0.name
#  }
#  node_selector         = var.netris.controller.node_selector
#  replicas              = var.netris.controller.replicas
#  resources             = var.netris.controller.resources
#  netris                = var.netris.controller.netris
#  ingress               = var.netris.controller.ingress
#  web_service_backend   = var.netris.controller.web_service_backend
#  web_service_frontend  = var.netris.controller.web_service_frontend
#  grpc                  = var.netris.controller.grpc
#  telescope             = var.netris.controller.telescope
#  telescope_notifier    = var.netris.controller.telescope_notifier
#  web_session_generator = var.netris.controller.web_session_generator
#  equinix_metal_agent   = var.netris.controller.equinix_metal_agent
#  phoenixnap_bmc_agent  = var.netris.controller.phoenixnap_bmc_agent
#  haproxy               = var.netris.controller.haproxy
#  depends_on            = [
#    kubernetes_namespace.vpc
#  ]
#}

#data "netris_tenant" "devops" {
#  name       = "DevOps"
#  depends_on = [module.netris-controller]
#}
#
#data "netris_site" "site" {
#  name       = "Default"
#  depends_on = [module.netris-controller]
#}
#
#resource "netris_subnet" "ingress" {
#  name       = "Ingress"
#  prefix     = "${var.istio.ingress_gateways.ingress.load_balancer_ip}/32"
#  tenantid   = data.netris_tenant.devops.id
#  purpose    = "load-balancer"
#  siteids    = [data.netris_site.site.id]
#  depends_on = [data.netris_tenant.devops, data.netris_site.site]
#}
#
#resource "netris_subnet" "eastwest" {
#  name       = "EastWest"
#  prefix     = "${var.istio.ingress_gateways.east_west.load_balancer_ip}/32"
#  tenantid   = data.netris_tenant.devops.id
#  purpose    = "load-balancer"
#  siteids    = [data.netris_site.site.id]
#  depends_on = [data.netris_tenant.devops, data.netris_site.site]
#}
#
#module "netris-operator" {
#  source    = "../../modules/netris/operator"
#  namespace = {
#    create = false
#    name   = kubernetes_namespace.vpc.metadata.0.name
#  }
#  node_selector = var.netris.operator.node_selector
#  replicas      = var.netris.operator.replicas
#  resources     = var.netris.operator.resources
#  controller    = merge(var.netris.operator.controller, { insecure = false })
#  log_level     = var.netris.operator.log.level
#  depends_on    = [
#    kubernetes_namespace.vpc
#  ]
#}
#
## -------------------------------------------------------SPIRE----------------------------------------------------------
#module "spire-server" {
#  source    = "../../modules/spire/server"
#  namespace = {
#    create = false
#    name   = kubernetes_namespace.security.metadata.0.name
#  }
#  trust_bundle = {
#    create = true
#    name   = "trust-bundle"
#  }
#  cluster_name               = local.kube.cluster_name
#  trust_domain               = local.kube.cluster_name
#  service_account_allow_list = ["${kubernetes_namespace.security.metadata[0].name}:spire-agent"]
#  plugins                    = [
#    <<-EOT
#      UpstreamAuthority "cert-manager" {
#        plugin_data {
#          issuer_kind = "${module.ca-issuer.kind}"
#          issuer_name = "${module.ca-issuer.name}"
#          issuer_group = "${module.ca-issuer.group}"
#          namespace = "${module.ca-issuer.namespace.name}"
#        }
#      }
#    EOT
#  ]
#  log_level  = var.security.spire.server.log.level
#  depends_on = [
#    kubernetes_namespace.security,
#    module.ca-issuer,
#  ]
#}
#
#module "spire-agent" {
#  source    = "../../modules/spire/agent"
#  namespace = {
#    create = false
#    name   = kubernetes_namespace.security.metadata.0.name
#  }
#  trust_bundle = {
#    create = false
#    name   = "trust-bundle"
#  }
#  cluster_name = local.kube.cluster_name
#  trust_domain = local.kube.cluster_name
#  spire_server = var.security.spire.agent.spire_server
#  log_level    = var.security.spire.agent.log.level
#  crds         = {
#    enabled = false
#  }
#  depends_on = [
#    kubernetes_namespace.security,
#    module.spire-server,
#  ]
#}
## -------------------------------------------------------ISTIO----------------------------------------------------------
#module "istiod-ca-cert" {
#  source = "../../modules/olm/cert-manager/crd"
#
#  kind = "Certificate"
#
#  metadata = {
#    namespace = module.istio-operator.namespace.name
#    name      = "istiod-ca-cert"
#  }
#
#  spec = {
#    isCa        = true
#    duration    = var.istio.pilot.ca.cert.duration
#    renewBefore = var.istio.pilot.ca.cert.renew_before
#    secretName  = "istiod-ca-cert"
#    commonName  = "istiod.${module.istio-operator.namespace.name}.svc"
#    privateKey  = var.istio.pilot.ca.cert.private_key
#    subject     = {
#      organizations = [
#        "cert-manager",
#      ]
#    }
#    usages = [
#      "digital signature",
#      "key encipherment",
#      "cert sign",
#    ]
#    dnsNames = ["istiod.${module.istio-operator.namespace.name}.svc"]
#    issuer    = {
#      kind  = module.ca-issuer.kind
#      name  = module.ca-issuer.metadata.name
#      group = "cert-manager.io"
#    }
#  }
#
#  depends_on = [
#    module.ca-issuer,
#    module.istio-operator,
#  ]
#}
#
#module "istio-northsouthgateway-ca-cert" {
#  source    = "../../modules/cert-manager/certificate"
#  namespace = {
#    create = false
#    name   = module.istio-operator.namespace.name
#  }
#  name         = "istio-northsouthgateway-ca-cert"
#  is_ca        = true
#  duration     = var.istio.pilot.ca.cert.duration
#  renew_before = var.istio.pilot.ca.cert.renew_before
#  secret_name  = "istio-northsouthgateway-ca-cert"
#  common_name  = "istio-northsouthgateway.${module.istio-operator.namespace.name}.svc"
#  private_key  = var.istio.pilot.ca.cert.private_key
#  subject      = {
#    organizations = ["cert-manager"]
#  }
#  usages = [
#    "digital signature",
#    "key encipherment",
#    "cert sign",
#  ]
#  dns_names = ["istio-northsouthgateway.${module.istio-operator.namespace.name}.svc"]
#  issuer    = {
#    kind  = module.ca-issuer.kind
#    name  = module.ca-issuer.name
#    group = module.ca-issuer.group
#  }
#  depends_on = [
#    module.ca-issuer,
#    module.istio-operator
#  ]
#}
#
#module "istio-eastwestgateway-ca-cert" {
#  source    = "../../modules/cert-manager/certificate"
#  namespace = {
#    create = false
#    name   = module.istio-operator.namespace.name
#  }
#  name         = "istio-eastwestgateway-ca-cert"
#  is_ca        = true
#  duration     = var.istio.pilot.ca.cert.duration
#  renew_before = var.istio.pilot.ca.cert.renew_before
#  secret_name  = "istio-eastwestgateway-ca-cert"
#  common_name  = "istio-eastwestgateway.${module.istio-operator.namespace.name}.svc"
#  private_key  = var.istio.pilot.ca.cert.private_key
#  subject      = {
#    organizations = ["cert-manager"]
#  }
#  usages = [
#    "digital signature",
#    "key encipherment",
#    "cert sign",
#  ]
#  dns_names = ["istio-eastwestgateway.${module.istio-operator.namespace.name}.svc"]
#  issuer    = {
#    kind  = module.ca-issuer.kind
#    name  = module.ca-issuer.name
#    group = module.ca-issuer.group
#  }
#  depends_on = [
#    module.ca-issuer,
#    module.istio-operator
#  ]
#}
#
#
#module "istio" {
#  source    = "../../modules/istio/operator/istio"
#  namespace = {
#    create = false
#    name   = module.istio-operator.namespace.name
#  }
#  name = "istiocontrolplane"
#  spec = {
#    hub        = var.istio.hub
#    tag        = var.istio.tag
#    profile    = "minimal"
#    meshConfig = {
#      trustDomain           = local.kube.cluster_name
#      enableTracing         = true
#      accessLogFile         = "/dev/stdout"
#      accessLogEncoding     = "JSON"
#      outboundTrafficPolicy = {
#        mode = "ALLOW_ANY"
#      }
#      defaultConfig = {
#        discoveryAddress = "istiod.${module.istio-operator.namespace.name}.svc:15012"
#        meshId           = local.kube.cluster_name
#        proxyMetadata    = {
#          # Enable basic DNS proxying
#          ISTIO_META_DNS_CAPTURE       = "true"
#          # Enable automatic address allocation, optional
#          ISTIO_META_DNS_AUTO_ALLOCATE = "true"
#        }
#        tracing = {
#          zipkin = {
#            address = "jaeger-collector.${kubernetes_namespace.observability.metadata.0.name}.svc.cluster.local:9411"
#          }
#          sampling            = 1
#          max_path_tag_length = 256
#        }
#      }
#      enablePrometheusMerge = true
#      # Enable http2 exchange between sidecars
#      #      h2UpgradePolicy       = "UPGRADE"
#      # Istio onfig namespace
#      rootNamespace         = module.istio-operator.namespace.name
#    }
#    # Traffic management
#    components = {
#      base = {
#        enabled = true
#      }
#      pilot = {
#        enabled   = true
#        namespace = kubernetes_namespace.proxy.metadata.0.name
#        k8s       = {
#          env = [
#            {
#              # If enabled, if user introduces new intermediate plug-in CA, user need not to restart istiod to pick up certs.
#              # Istiod picks newly added intermediate plug-in CA certs and updates it. Plug-in new Root-CA not supported.
#              name  = "AUTO_RELOAD_PLUGIN_CERTS"
#              value = "true"
#            },
#            {
#              name  = "PILOT_ENABLE_STATUS"
#              value = "true"
#            },
#            # Allow multiple trust domains (Required for Gloo Mesh east/west routing)
#            {
#              name  = "PILOT_SKIP_VALIDATE_TRUST_DOMAIN"
#              value = "true"
#            }
#          ]
#          nodeSelector = var.istio.pilot.node_selector
#          # Recommended to be >1 in production
#          replicaCount = var.istio.pilot.replicas
#          # The Istio load tests mesh consists of 1000 services and 2000 sidecars with 70,000 mesh-wide
#          # requests per second and Istiod used 1 vCPU and 1.5 GB of memory.
#          resources    = var.istio.pilot.resources
#          # Recommended to scale istiod under load
#          hpaSpec      = var.istio.pilot.autoscaling.enabled? {
#            minReplicas = var.istio.pilot.autoscaling.min_replicas
#            maxReplicas = var.istio.pilot.autoscaling.max_replicas
#            metrics     = [
#              {
#                resource = {
#                  name                     = "cpu"
#                  targetAverageUtilization = var.istio.pilot.autoscaling.target_average_utilization
#                }
#                type = "Resource"
#              },
#            ]
#            scaleTargetRef = {
#              apiVersion = "apps/v1"
#              kind       = "Deployment"
#              name       = "istiod"
#            }
#          } : null
#          strategy = {
#            rollingUpdate = {
#              maxSurge       = "100%"
#              maxUnavailable = "25%"
#            }
#          }
#          overlays = [
#            {
#              apiVersion = "apps/v1"
#              kind       = "Deployment"
#              name       = "istiod"
#              patches    = flatten([
#                {
#                  path  = "spec.template.spec.volumes[name:cacerts]"
#                  value = {
#                    name   = "cacerts"
#                    secret = {
#                      secretName : module.istiod-ca-cert.secret_name
#                    }
#                  }
#                },
#                {
#                  path  = "spec.template.spec.containers.[name:discovery].args[-1]"
#                  value = "--log_output_level=default:info"
#                },
#                var.istio.pilot.consul==null?[] : [
#                  {
#                    path  = "spec.template.spec.containers.[name:discovery].args[-1]"
#                    value = "--consulserverURL=${var.istio.pilot.consul["address"]}:${var.istio.pilot.consul["port"]}"
#                  },
#                  {
#                    path  = "spec.template.spec.containers.[name:discovery].args[-1]"
#                    value = "--registries=Kubernetes,Consul"
#                  },
#                ]
#              ])
#            },
#          ]
#        }
#      }
#      cni = {
#        enabled   = true
#        namespace = "kube-system"
#        #        k8s = {
#        #          nodeSelector = var.istio.cni.node_selector
#        #          replicaCount = var.istio.cni.replicas
#        #          resources    = var.istio.cni.resources
#        #        }
#      }
#      istiodRemote = {
#        enabled = false
#      }
#      # Istio Gateway feature
#      ingressGateways = [
#        {
#          enabled   = true
#          namespace = kubernetes_namespace.proxy.metadata.0.name
#          name      = "istio-northsouthgateway"
#          label     = {
#            app   = "northsouthgateway"
#            istio = "northsouthgateway"
#          }
#          k8s = {
#            nodeSelector = var.istio.ingress_gateways.north_south.node_selector
#            replicaCount = var.istio.ingress_gateways.north_south.replicas
#            hpaSpec      = var.istio.ingress_gateways.north_south.autoscaling.enabled? {
#              minReplicas = var.istio.ingress_gateways.north_south.autoscaling.min_replicas
#              maxReplicas = var.istio.ingress_gateways.north_south.autoscaling.max_replicas
#              metrics     = [
#                {
#                  resource = {
#                    name                     = "cpu"
#                    targetAverageUtilization = var.istio.ingress_gateways.north_south.autoscaling.target_average_utilization
#                  }
#                  type = "Resource"
#                },
#              ]
#              scaleTargetRef = {
#                apiVersion = "apps/v1"
#                kind       = "Deployment"
#                name       = "istio-northsouthgateway"
#              }
#            } : null
#            resources = var.istio.ingress_gateways.north_south.resources
#            service   = {
#              loadBalancerIP = var.istio.ingress_gateways.north_south.load_balancer_ip
#            }
#            strategy = {
#              rollingUpdate = {
#                maxSurge       = "100%"
#                maxUnavailable = "25%"
#              }
#            }
#            overlays = [
#              {
#                apiVersion = "v1"
#                kind       = "Service"
#                name       = "istio-northsouthgateway"
#                patches    = [
#                  {
#                    path  = "spec.ports"
#                    value = [
#                      {
#                        name       = "status-port"
#                        port       = 15021
#                        protocol   = "TCP"
#                        targetPort = 15021
#                      },
#                      {
#                        name       = "http2"
#                        port       = 80
#                        protocol   = "TCP"
#                        targetPort = 8080
#                      },
#                      {
#                        name       = "https"
#                        port       = 443
#                        protocol   = "TCP"
#                        targetPort = 8443
#                      },
#                      {
#                        name       = "tls-passthrough"
#                        port       = 10443
#                        protocol   = "TCP"
#                        targetPort = 8443
#                      },
#                    ]
#                  },
#                ]
#              },
#            ]
#          }
#        },
#        {
#          enabled   = true
#          namespace = kubernetes_namespace.proxy.metadata.0.name
#          name      = "istio-eastwestgateway"
#          label     = {
#            app   = "eastwestgateway"
#            istio = "eastwestgateway"
#          }
#          k8s = {
#            nodeSelector = var.istio.ingress_gateways.east_west.node_selector
#            replicaCount = var.istio.ingress_gateways.east_west.replicas
#            hpaSpec      = var.istio.ingress_gateways.east_west.autoscaling.enabled? {
#              minReplicas = var.istio.ingress_gateways.east_west.autoscaling.min_replicas
#              maxReplicas = var.istio.ingress_gateways.east_west.autoscaling.max_replicas
#              metrics     = [
#                {
#                  resource = {
#                    name                     = "cpu"
#                    targetAverageUtilization = var.istio.ingress_gateways.east_west.autoscaling.target_average_utilization
#                  }
#                  type = "Resource"
#                },
#              ]
#              scaleTargetRef = {
#                apiVersion = "apps/v1"
#                kind       = "Deployment"
#                name       = "istio-eastwestgateway"
#              }
#            } : null
#            resources = var.istio.ingress_gateways.east_west.resources
#            service   = {
#              loadBalancerIP = var.istio.ingress_gateways.east_west.load_balancer_ip
#            }
#            strategy = {
#              rollingUpdate = {
#                maxSurge       = "100%"
#                maxUnavailable = "25%"
#              }
#            }
#            overlays = [
#              {
#                apiVersion = "v1"
#                kind       = "Service"
#                name       = "istio-eastwestgateway"
#                patches    = [
#                  {
#                    path  = "spec.ports"
#                    value = [
#                      {
#                        name       = "status-port"
#                        port       = 15021
#                        protocol   = "TCP"
#                        targetPort = 15021
#                      },
#                      {
#                        name       = "http2"
#                        port       = 80
#                        protocol   = "TCP"
#                        targetPort = 8080
#                      },
#                      {
#                        name       = "https"
#                        port       = 443
#                        protocol   = "TCP"
#                        targetPort = 8443
#                      },
#                      {
#                        name       = "tls-passthrough"
#                        port       = 10443
#                        protocol   = "TCP"
#                        targetPort = 8443
#                      },
#                    ]
#                  },
#                ]
#              },
#            ]
#          }
#        },
#      ]
#      egressGateways = [
#        {
#          enabled   = true
#          namespace = kubernetes_namespace.proxy.metadata.0.name
#          name      = "istio-egressgateway"
#          label     = {
#            app   = "egressgateway"
#            istio = "egressgateway"
#          }
#          k8s = {
#            nodeSelector = var.istio.egress_gateway.node_selector
#            replicaCount = var.istio.egress_gateway.replicas
#            hpaSpec      = var.istio.egress_gateway.autoscaling.enabled? {
#              minReplicas = var.istio.egress_gateway.autoscaling.min_replicas
#              maxReplicas = var.istio.egress_gateway.autoscaling.max_replicas
#              metrics     = [
#                {
#                  resource = {
#                    name                     = "cpu"
#                    targetAverageUtilization = var.istio.egress_gateway.autoscaling.target_average_utilization
#
#
#                  }
#                  type = "Resource"
#                },
#              ]
#              scaleTargetRef = {
#                apiVersion = "apps/v1"
#                kind       = "Deployment"
#                name       = "istio-egressgateway"
#              }
#            } : null
#            resources = var.istio.egress_gateway.resources
#            strategy  = {
#              rollingUpdate = {
#                maxSurge       = "100%"
#                maxUnavailable = "25%"
#              }
#            }
#          }
#        },
#      ]
#    }
#    addonComponents = {
#      istiocoredns = {
#        enabled = true
#      }
#    }
#    values = {
#      global = {
#        istioNamespace = module.istio-operator.namespace.name
#        istiod         = {
#          enableAnalysis = true
#        }
#        multiCluster = {
#          clusterName = local.kube.cluster_name
#        }
#        proxy = {
#          logLevel  = var.istio.sidecar.log.level
#          resources = var.istio.sidecar.resources
#        }
#        network = local.kube.cluster_name
#      }
#      # To resolve too many open files error of istio-cni the following two lines was added to /etc/sysctl.conf:
#      # fs.inotify.max_user_watches=1048576
#      # fs.inotify.max_user_instances=1024
#      cni = {
#        ambient = {
#          enabled      = true
#          redirectMode = "ebpf"
#        }
#        repair = {
#          enabled = true
#        }
#        excludeNamespaces = [
#          kubernetes_namespace.proxy.metadata.0.name,
#          "kube-system",
#        ]
#        chained         = false
#        cniBinDir       = "/opt/cni/bin"
#        # To integrate with multus-multinetwork kubernetes cni.
#        cniConfDir      = "/etc/cni/multus/net.d"
#        cniConfFileName = "istio-cni.conf"
#        logLevel        = var.istio.cni.log.level
#      }
#      # This is used to customize the sidecar template
#      sidecarInjectorWebhook = {
#        injectedAnnotations = {
#          "k8s.v1.cni.cncf.io/networks" = "istio-cni"
#        }
#      }
#    }
#  }
#  depends_on = [
#    module.netris-operator,
#    module.spire-agent,
#    module.istio-operator,
#    module.istiod-ca-cert,
#    module.istio-northsouthgateway-ca-cert,
#    module.istio-eastwestgateway-ca-cert,
#  ]
#}
#
## CNI managed by Multus requires a NetworkAttachmentDefinition to be present in the application namespace in order to invoke the istio-cni plugin.
#resource "kubernetes_manifest" "network-attachment-definition-default" {
#  manifest = {
#    apiVersion = "k8s.cni.cncf.io/v1"
#    kind       = "NetworkAttachmentDefinition"
#    metadata   = {
#      namespace = "default"
#      name      = "istio-cni"
#    }
#  }
#  depends_on = [
#    module.istio,
#  ]
#}
#
#resource "kubernetes_manifest" "network-attachment-definition-network" {
#  manifest = {
#    apiVersion = "k8s.cni.cncf.io/v1"
#    kind       = "NetworkAttachmentDefinition"
#    metadata   = {
#      namespace = kubernetes_namespace.network.metadata.0.name
#      name      = "istio-cni"
#    }
#  }
#  depends_on = [
#    kubernetes_namespace.network,
#    module.istio,
#  ]
#}
#
#resource "kubernetes_manifest" "network-attachment-definition-security" {
#  manifest = {
#    apiVersion = "k8s.cni.cncf.io/v1"
#    kind       = "NetworkAttachmentDefinition"
#    metadata   = {
#      namespace = kubernetes_namespace.security.metadata.0.name
#      name      = "istio-cni"
#    }
#  }
#  depends_on = [
#    kubernetes_namespace.security,
#    module.istio,
#  ]
#}
#
#resource "kubernetes_manifest" "network-attachment-definition-storage" {
#  manifest = {
#    apiVersion = "k8s.cni.cncf.io/v1"
#    kind       = "NetworkAttachmentDefinition"
#    metadata   = {
#      namespace = kubernetes_namespace.storage.metadata.0.name
#      name      = "istio-cni"
#    }
#  }
#  depends_on = [
#    kubernetes_namespace.storage,
#    module.istio,
#  ]
#}
#
#resource "kubernetes_manifest" "network-attachment-definition-observability" {
#  manifest = {
#    apiVersion = "k8s.cni.cncf.io/v1"
#    kind       = "NetworkAttachmentDefinition"
#    metadata   = {
#      namespace = kubernetes_namespace.observability.metadata.0.name
#      name      = "istio-cni"
#    }
#  }
#  depends_on = [
#    kubernetes_namespace.observability,
#    module.istio,
#  ]
#}
#
#resource "kubernetes_manifest" "network-attachment-definition-compute" {
#  manifest = {
#    apiVersion = "k8s.cni.cncf.io/v1"
#    kind       = "NetworkAttachmentDefinition"
#    metadata   = {
#      namespace = kubernetes_namespace.compute.metadata.0.name
#      name      = "istio-cni"
#    }
#  }
#  depends_on = [
#    kubernetes_namespace.compute,
#    module.istio,
#  ]
#}
#
#
#module "northsouth-gateway" {
#  source    = "../../modules/istio/gateway"
#  namespace = {
#    create = false
#    name   = module.istio-operator.namespace.name
#  }
#  name = "northsouth-gateway"
#  spec = {
#    selector = {
#      istio = "northsouthgateway"
#    }
#    servers = [
#      {
#        hosts = [
#          "*",
#        ]
#        port = {
#          name     = "http"
#          number   = 80
#          protocol = "HTTP"
#        }
#        tls = {
#          httpsRedirect = true # If you serve HTTPS and want to 301 redirect http requests
#        }
#      },
#      {
#        hosts = [
#          "*",
#        ]
#        port = {
#          name     = "https"
#          number   = 443
#          protocol = "HTTPS"
#        }
#        tls = {
#          mode           = "SIMPLE"
#          credentialName = module.istio-northsouthgateway-ca-cert.secret_name
#        }
#      },
#      {
#        hosts = [
#          "*",
#        ]
#        port = {
#          name     = "tls-passthrough"
#          number   = 10443
#          protocol = "TLS"
#        }
#        tls = {
#          mode = "PASSTHROUGH"
#        }
#      },
#    ]
#  }
#  depends_on = [
#    module.istio,
#  ]
#}
#
#module "eastwest-gateway" {
#  source    = "../../modules/istio/gateway"
#  namespace = {
#    create = false
#    name   = module.istio-operator.namespace.name
#  }
#  name = "eastwest-gateway"
#  spec = {
#    selector = {
#      istio = "eastwestgateway"
#    }
#    servers = [
#      {
#        hosts = [
#          "*",
#        ]
#        port = {
#          name     = "http"
#          number   = 80
#          protocol = "HTTP"
#        }
#        tls = {
#          httpsRedirect = true # If you serve HTTPS and want to 301 redirect http requests
#        }
#      },
#      {
#        hosts = [
#          "*",
#        ]
#        port = {
#          name     = "https"
#          number   = 443
#          protocol = "HTTPS"
#        }
#        tls = {
#          mode           = "SIMPLE"
#          credentialName = module.istio-northsouthgateway-ca-cert.secret_name
#        }
#      },
#      {
#        hosts = [
#          "*",
#        ]
#        port = {
#          name     = "tls-passthrough"
#          number   = 10443
#          protocol = "TLS"
#        }
#        tls = {
#          mode = "PASSTHROUGH"
#        }
#      },
#    ]
#  }
#  depends_on = [
#    module.istio,
#  ]
#}

# -------------------------------------------------------VAULT----------------------------------------------------------
module "vault-operator" {
  source = "../../modules/vault/operator"

  namespace = {
    create   = false
    metadata = {
      name = kubernetes_namespace.security.metadata.0.name
    }
  }

  name = "vault-operator"

  affinity      = var.security.vault.operator.affinity
  node_selector = var.security.vault.operator.node_selector
  tolerations   = var.security.vault.operator.tolerations
  resources     = var.security.vault.operator.resources

  depends_on = [
    kubernetes_namespace.security,
  ]
}

module "vault" {
  source = "../../modules/vault/operator/crd"

  kind = "Vault"

  metadata = {
    namespace = kubernetes_namespace.security.metadata.0.name
    name      = "vault"
  }

  spec = {
    bankVaultsImage = "banzaicloud/bank-vaults:master"
    image           = var.security.vault.image
    nodeSelector    = var.security.vault.node_selector
    size            = var.security.vault.replicas
    resources       = var.security.vault.resources
    unsealConfig    = {
      kubernetes = {
        secretNamespace = kubernetes_namespace.security.metadata.0.name
      }
      options = {
        preFlightChecks = true
        storeRootToken  = true
      }
    }
    config = {
      cluster_name = local.kube.cluster_name
      ui           = true
      api_addr     = "http://0.0.0.0:8200"
      cluster_addr = "http://0.0.0.0:8201"
      listener     = {
        tcp = {
          address         = "0.0.0.0:8200"
          cluster_address = "0.0.0.0:8200"
          tls_disable     = true
        }
      }
      disable_mlock = true
      storage       = {
        raft = {
          path = "/vault/file"
        }
      }
      log_level  = var.security.vault.log.level
      log_format = var.security.vault.log.format
    }
    externalConfig = {
      auth = [
        {
          type  = "kubernetes"
          roles = [
            {
              name                        = "default"
              bound_service_account_names = [
                "default",
                "vault-secrets-webhook",
              ]
              bound_service_account_namespaces = [
                "default",
                "vswh",
              ]
              policies = "allow_secrets"
              ttl      = "1h"
            },
          ]
        },
      ]
      policies       = jsondecode(file("${path.module}/files/vault/policies/policies.json"))
      secrets        = jsondecode(file("${path.module}/files/vault/secrets/secrets.json"))
      startupSecrets = jsondecode(file("${path.module}/files/vault/secrets/startup-secrets.json"))
    }
    volumeClaimTemplates = [
      {
        metadata = {
          name = "vault-raft"
        }
        spec = {
          accessModes = [
            "ReadWriteOnce",
          ]
          resources = {
            requests = {
              storage = "1Gi"
            }
          }
          volumeMode = "Filesystem"
        }
      },
    ]
    volumeMounts = [
      {
        mountPath = "/vault/file"
        name      = "vault-raft"
      },
    ]
    statsdDisabled = true
    veleroEnabled  = true
    ingress        = {
      enabled = false
    }
  }
  depends_on = [
    kubernetes_namespace.security,
    module.vault-operator,
  ]
}

#module "vault-virtual-service" {
#  source    = "../../modules/istio/virtual-service"
#  namespace = {
#    create = false
#    name   = module.istio.namespace.name
#  }
#  name = "vault-vs"
#  spec = {
#    gateways = [
#      module.northsouth-gateway.name,
#      module.eastwest-gateway.name,
#    ]
#    hosts = [
#      "vault.${module.vault.namespace.name}.svc.cluster.local",
#    ]
#    http = [
#      {
#        name  = "vault"
#        match = [
#          {
#            uri = {
#              prefix = "/vault/"
#            }
#          },
#        ]
#        route = [
#          {
#            destination = {
#              host = "vault"
#              port = {
#                number = 8200
#              }
#            }
#          },
#        ]
#      },
#    ]
#  }
#  depends_on = [
#    module.northsouth-gateway,
#    module.eastwest-gateway,
#    module.vault,
#  ]
#}

# -------------------------------------------------------REDIS----------------------------------------------------------
module "kafka-operator" {
  source = "../../modules/olm/crd/v1alpha1"

  kind = "Subscription"

  metadata = {
    namespace = module.global-operator-group.metadata.namespace
    name      = "kafka-operator"
  }

  spec = {
    channel         = "stable"
    name            = "strimzi-kafka-operator"
    source          = "operatorhubio-catalog"
    sourceNamespace = module.olm.namespace.metadata.name
    config          = {
      affinity     = var.storage.kafka.operator.affinity
      nodeSelector = var.storage.kafka.operator.nodeSelector
      selector     = var.storage.kafka.operator.selector
      tolerations  = var.storage.kafka.operator.tolerations
      resources    = var.storage.kafka.operator.resources
    }
    env = [
      {
        name  = "ARGS"
        value = "-v=10"
      },
    ]
  }

  depends_on = [
    module.global-operator-group,
  ]
}

module "kafka" {
  source = "../../modules/olm/kafka/crd"

  kind = "Kafka"

  metadata = {
    namespace = kubernetes_namespace.storage.metadata.0.name
    name      = "kafka"
  }

  spec = {
    kafka = {
      version  = "3.4.1"
      replicas = 1
      config   = {
        "default.replication.factor"               = 3
        "inter.broker.protocol.version"            = "3.4"
        "min.insync.replicas"                      = 2
        "offsets.topic.replication.factor"         = 3
        "transaction.state.log.min.isr"            = 2
        "transaction.state.log.replication.factor" = 3
      }
      listeners = [
        {
          name = "plain"
          port = 9092
          tls  = false
          type = "internal"
        },
        {
          name = "tls"
          port = 9093
          tls  = true
          type = "internal"
        },
      ]
      storage = {
        type = "ephemeral"
      }
    }
    zookeeper = {
      replicas = 1
      storage  = {
        type = "ephemeral"
      }
    }
    entityOperator = {
      topicOperator = {}
      userOperator  = {}
    }
  }

  depends_on = [
    kubernetes_namespace.storage,
    module.kafka-operator,
  ]
}

# -------------------------------------------------------REDIS----------------------------------------------------------
module "redis-operator" {
  source = "../../modules/olm/crd/v1alpha1"

  kind = "Subscription"

  metadata = {
    namespace = module.storage-operator-group.metadata.namespace
    name      = "redis-operator"
  }

  spec = {
    channel         = "stable"
    name            = "redis-operator"
    source          = "operatorhubio-catalog"
    sourceNamespace = module.olm.namespace.metadata.name
    config          = {
      affinity     = var.storage.redis.operator.affinity
      nodeSelector = var.storage.redis.operator.nodeSelector
      selector     = var.storage.redis.operator.selector
      tolerations  = var.storage.redis.operator.tolerations
      resources    = var.storage.redis.operator.resources
    }
    env = [
      {
        name  = "ARGS"
        value = "-v=10"
      },
    ]
  }

  depends_on = [
    module.storage-operator-group,
  ]
}

module "redis" {
  source = "../../modules/olm/redis/crd"

  kind = "RedisCluster"

  metadata = {
    namespace = kubernetes_namespace.storage.metadata.0.name
    name      = "redis"
  }

  spec = {
    clusterVersion  = "v7"
    clusterSize     = 1
    securityContext = {
      fsGroup   = 1000
      runAsUser = 1000
    }
    kubernetesConfig = {
      image           = "quay.io/opstree/redis:v7.0.5"
      imagePullPolicy = "IfNotPresent"
    }
    redisExporter = {
      enabled         = true
      image           = "quay.io/opstree/redis-exporter:v1.44.0"
      imagePullPolicy = "IfNotPresent"
    }
    persistenceEnabled = true
    storage            = {
      volumeClaimTemplate = {
        spec = {
          accessModes = [
            "ReadWriteOnce",
          ]
          resources = {
            requests = {
              storage = "1Gi"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.storage,
    module.redis-operator,
  ]
}

# -----------------------------------------------------HAZELCAST--------------------------------------------------------
module "hazelcast-platform-operator" {
  source = "../../modules/olm/crd/v1alpha1"

  kind = "Subscription"

  metadata = {
    namespace = module.storage-operator-group.metadata.namespace
    name      = "hazelcast-platform-operator"
  }

  spec = {
    channel         = "alpha"
    name            = "hazelcast-platform-operator"
    source          = "operatorhubio-catalog"
    sourceNamespace = module.olm.namespace.metadata.name
    config          = {
      affinity     = var.storage.hazelcast.operator.affinity
      nodeSelector = var.storage.hazelcast.operator.nodeSelector
      selector     = var.storage.hazelcast.operator.selector
      tolerations  = var.storage.hazelcast.operator.tolerations
      resources    = var.storage.hazelcast.operator.resources
    }
    env = [
      {
        name  = "ARGS"
        value = "-v=10"
      },
    ]
  }

  depends_on = [
    module.storage-operator-group,
  ]
}

module "hazelcast" {
  source = "../../modules/olm/hazelcast/crd"

  kind = "Hazelcast"

  metadata = {
    namespace = kubernetes_namespace.storage.metadata.0.name
    name      = "hazelcast"
  }

  spec = {
    repository  = "docker.io/hazelcast/hazelcast"
    version     = "5.3.0"
    clusterSize = 1
  }

  depends_on = [
    kubernetes_namespace.storage,
    module.hazelcast-platform-operator,
  ]
}

module "hazelcast-management-center" {
  source = "../../modules/olm/hazelcast/crd"

  kind = "ManagementCenter"

  metadata = {
    namespace = kubernetes_namespace.storage.metadata.0.name
    name      = "hazelcast-management-center"
  }

  spec = {
    repository           = "hazelcast/management-center"
    version              = "5.3.0"
    externalConnectivity = {
      type = "ClusterIP"
    }
    persistence = {
      enabled = true
      size    = "10Gi"
    }
    hazelcastClusters = [
      {
        address = "hazelcast"
        name    = "dev"
      },
    ]
  }

  depends_on = [
    module.hazelcast,
  ]
}

# ----------------------------------------------------POSTGRESQL--------------------------------------------------------
module "postgresql-operator" {
  source = "../../modules/olm/crd/v1alpha1"

  kind = "Subscription"

  metadata = {
    namespace = module.storage-operator-group.metadata.namespace
    name      = "postgresql-operator"
  }

  spec = {
    channel         = "v5"
    name            = "postgresql"
    source          = "operatorhubio-catalog"
    sourceNamespace = module.olm.namespace.metadata.name
    config          = {
      affinity     = var.storage.cert_manager.operator.affinity
      nodeSelector = var.storage.cert_manager.operator.nodeSelector
      selector     = var.storage.cert_manager.operator.selector
      tolerations  = var.storage.cert_manager.operator.tolerations
      resources    = var.storage.cert_manager.operator.resources
    }
    env = [
      {
        name  = "ARGS"
        value = "-v=10"
      },
    ]
  }

  depends_on = [
    module.storage-operator-group,
  ]
}

variable "postgresql_name" {
  type    = string
  default = "postgresql"
}

variable "postgresql_backup_repo_name" {
  type    = string
  default = "repo1"
}

resource "kubernetes_config_map" "postgresql-s3-init-db" {
  metadata {
    namespace = kubernetes_namespace.storage.metadata.0.name
    name      = "${var.postgresql_name}-init-db"
  }

  data = {
    "init.sql" = file("${path.module}/files/postgresql/database/init.sql")
  }
}

#resource "minio_bucket" "postgresql" {
#  name = var.postgresql_name
#}

resource "kubernetes_secret" "postgresql-s3-credentials" {
  metadata {
    namespace = kubernetes_namespace.storage.metadata.0.name
    name      = "${var.postgresql_name}-s3-creds"
  }

  data = {
    "s3.conf" = templatefile("${path.module}/files/postgresql/backups/s3.conf", {
      repo_name            = var.postgresql_backup_repo_name
      s3_access_key_id     = local.s3.access_key_id
      s3_secret_access_key = local.s3.secret_access_key
      cipher_pass          = "test"
    })
  }

  depends_on = [
    #    minio_bucket.postgresql,
  ]
}

module "postgresql" {
  source = "../../modules/olm/postgresql/crd"

  kind = "PostgresCluster"

  metadata = {
    namespace = kubernetes_namespace.storage.metadata.0.name
    name      = var.postgresql_name
  }

  spec = {
    image           = "registry.developers.crunchydata.com/crunchydata/crunchy-postgres:ubi8-15.3-0"
    postgresVersion = 15
    port            = 5432
    instances       = [
      {
        replicas            = 1
        name                = "instance1"
        dataVolumeClaimSpec = {
          accessModes = [
            "ReadWriteOnce",
          ]
          resources = {
            requests = {
              storage = "1Gi"
            }
            limits = {
              cpu    = "2.0"
              memory = "4Gi"
            }
          }
        }
      },
    ]
    backups = {
      image  = "registry.developers.crunchydata.com/crunchydata/crunchy-pgbackrest:ubi8-2.45-0"
      global = {
        "${var.postgresql_backup_repo_name}-path"                = "/pgbackrest/postgres-operator/${var.postgresql_name}-s3/${var.postgresql_backup_repo_name}"
        "${var.postgresql_backup_repo_name}-cipher-type"         = "aes-256-cbc"
        "${var.postgresql_backup_repo_name}-retention-full"      = "14"
        "${var.postgresql_backup_repo_name}-retention-full-type" = "time"
      }
      pgbackrest = {
        repos = [
          {
            name = var.postgresql_backup_repo_name
            s3   = {
              bucket   = var.postgresql_name
              endpoint = local.s3.endpoint
              region   = local.region
            }
            schedules = {
              full        = "0 1 * * *"
              incremental = "0 */6 * * *"
            }
          },
        ]
        configuration = [
          {
            secret = {
              name = kubernetes_secret.postgresql-s3-credentials.metadata.0.name
            }
          },
        ]
        manual = {
          repoName = var.postgresql_backup_repo_name
          options  = [
            "--type=full",
          ]
        }
        restore = {
          enabled  = true
          repoName = var.postgresql_backup_repo_name
        }
      }
    }
    # PostgreSQL supports synchronous replication, which is a replication mode designed to limit the risk of transaction loss.
    # Synchronous replication waits for a transaction to be written to at least one additional server before it considers the transaction to be committed.
    patroni = {
      dynamicConfiguration = {
        postgresql = {
          parameters = {
            synchronous_commit   = "on"
            max_parallel_workers = 3
            max_worker_processes = 3
            shared_buffers       = "1GB"
            work_mem             = "2MB"
          }
        }
        synchronous_mode = true
      }
    }
    proxy = {
      pgBouncer = {
        image  = "registry.developers.crunchydata.com/crunchydata/crunchy-pgbouncer:ubi8-1.19-0"
        config = {
          global = {
            ignore_startup_parameters = "extra_float_digits,search_path"
          }
        }
      }
    }
    users           = jsondecode( file("${path.module}/files/postgresql/database/users.json"))
    databaseInitSQL = {
      key  = "init.sql"
      name = kubernetes_config_map.postgresql-s3-init-db.metadata.0.name
    }
  }

  depends_on = [
    kubernetes_namespace.storage,
    module.postgresql-operator,
    kubernetes_config_map.postgresql-s3-init-db,
    kubernetes_secret.postgresql-s3-credentials,
  ]
}

# -----------------------------------------------------KEYCLOAK---------------------------------------------------------
module "keycloak-operator" {
  source = "../../modules/olm/crd/v1alpha1"

  kind = "Subscription"

  metadata = {
    namespace = module.security-operator-group.metadata.namespace
    name      = "keycloak-operator"
  }

  spec = {
    channel         = "fast"
    name            = "keycloak-operator"
    source          = "operatorhubio-catalog"
    sourceNamespace = module.olm.namespace.metadata.name
    config          = {
      affinity     = var.security.cert_manager.operator.affinity
      nodeSelector = var.security.cert_manager.operator.nodeSelector
      selector     = var.security.cert_manager.operator.selector
      tolerations  = var.security.cert_manager.operator.tolerations
      resources    = var.security.cert_manager.operator.resources
    }
    env = [
      {
        name  = "ARGS"
        value = "-v=10"
      },
    ]
  }

  depends_on = [
    module.security-operator-group,
  ]
}

variable "keycloak_name" {
  type    = string
  default = "keycloak"
}

module "keycloak" {
  source = "../../modules/olm/keycloak/crd"

  kind = "Keycloak"

  metadata = {
    namespace = kubernetes_namespace.security.metadata.0.name
    labels    = {
      app = "sso"
    }
    name = var.keycloak_name
  }

  spec = {
    image     = "quay.io/keycloak/keycloak:21.1"
    instances = 1
    http      = {
      httpEnabled = true
    }
    hostname = {
      strict            = false
      strictBackchannel = false
    }
  }

  depends_on = [
    kubernetes_namespace.security,
    module.keycloak-operator,
  ]
}

module "keycloak-realm-import" {
  for_each = fileset(path.module, "/files/keycloak/realms/*.json")

  source = "../../modules/olm/keycloak/crd"

  kind = "KeycloakRealmImport"

  metadata = {
    namespace = kubernetes_namespace.security.metadata.0.name
    labels    = {
      app = "sso"
    }
    name = "keycloak-realm-import-${trimsuffix(basename(each.value),".json")}"
  }

  spec = {
    keycloakCRName = var.keycloak_name
    realm          = jsondecode(file("${path.module}/${each.value}"))
  }

  depends_on = [
    module.keycloak,
  ]
}

#module "keycloak-virtual-service" {
#  source    = "../../modules/istio/virtual-service"
#  namespace = {
#    create = false
#    name   = module.istio.namespace.name
#  }
#  name = "keycloak-vs"
#  spec = {
#    gateways = [
#      module.northsouth-gateway.name,
#      module.eastwest-gateway.name,
#    ]
#    http = [
#      {
#        name  = "keycloak"
#        match = [
#          {
#            uri = {
#              prefix = "/keycloak/"
#            }
#          },
#        ]
#        route = [
#          {
#            destination = {
#              host = "keycloak-service.${module.keycloak.namespace.name}.svc.cluster.local"
#              port = {
#                number = 8180
#              }
#            }
#          },
#        ]
#      },
#    ]
#    hosts = [
#      "*",
#    ]
#  }
#  depends_on = [
#    module.northsouth-gateway,
#    module.eastwest-gateway,
#    module.keycloak,
#  ]
#}


# ------------------------------------------------------JAEGER----------------------------------------------------------
module "jaeger-operator" {
  source = "../../modules/olm/crd/v1alpha1"

  kind = "Subscription"

  metadata = {
    namespace = module.global-operator-group.metadata.namespace
    name      = "jaeger-operator"
  }

  spec = {
    channel         = "stable"
    name            = "jaeger"
    source          = "operatorhubio-catalog"
    sourceNamespace = module.olm.namespace.metadata.name
    config          = {
      affinity     = var.observability.cert_manager.operator.affinity
      nodeSelector = var.observability.cert_manager.operator.nodeSelector
      selector     = var.observability.cert_manager.operator.selector
      tolerations  = var.observability.cert_manager.operator.tolerations
      resources    = var.observability.cert_manager.operator.resources
    }
    env = [
      {
        name  = "ARGS"
        value = "-v=10"
      },
    ]
  }

  depends_on = [
    module.global-operator-group,
  ]
}

module "jaeger" {
  source = "../../modules/olm/jaeger/crd"

  kind = "Jaeger"

  metadata = {
    namespace = kubernetes_namespace.observability.metadata.0.name
    name      = "jaeger"
  }

  spec = {
    strategy = "production"
    allInOne = {
      image   = "jaegertracing/all-in-one:1"
      options = {
        log-level = "debug"
        query     = {
          base-path = "/jaeger"
        }
      }
    }
    storage = {
      options = {
        memory = {
          max-traces = 100000
        }
      }
    }
    ui = {
      options = {
        dependencies = {
          dagMaxNumServices = 200,
          menuEnabled       = true
        }
        menu = [
          {
            items = [
              {
                "label" : "GitHub",
                "url" : "https://github.com/jaegertracing/jaeger"
              },
              {
                label = "Documentation"
                url   = "https://www.jaegertracing.io/docs/latest"
              },
            ]
            label = "About Jaeger"
          },
        ]
        archiveEnabled = true,
        tracking       = {
          gaID        = "UA-000000-2"
          trackErrors = true
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.observability,
    module.jaeger-operator,
  ]
}

#module "jaeger-virtual-service" {
#  source    = "../../modules/istio/virtual-service"
#  namespace = {
#    create = false
#    name   = module.istio.namespace.name
#  }
#  name = "jaeger-vs"
#  spec = {
#    gateways = [
#      module.northsouth-gateway.name,
#      module.eastwest-gateway.name,
#    ]
#    hosts = [
#      "*",
#    ]
#    http = [
#      {
#        name  = "jaeger"
#        match = [
#          {
#            uri = {
#              prefix = "/jaeger/"
#            }
#          },
#        ]
#        route = [
#          {
#            destination = {
#              host = "jaeger-query.${kubernetes_namespace.observability.metadata.0.name}.svc.cluster.local"
#              port = {
#                number = 16686
#              }
#            }
#          },
#        ]
#      },
#    ]
#  }
#  depends_on = [
#    module.northsouth-gateway,
#    module.eastwest-gateway,
#    module.jaeger
#  ]
#}

# -------------------------------------------------------LOKI-----------------------------------------------------------
module "loki-operator" {
  source = "../../modules/olm/crd/v1alpha1"

  kind = "Subscription"

  metadata = {
    namespace = module.global-operator-group.metadata.namespace
    name      = "loki-operator"
  }

  spec = {
    channel         = "alpha"
    name            = "loki-operator"
    source          = "operatorhubio-catalog"
    sourceNamespace = module.olm.namespace.metadata.name
    config          = {
      affinity     = var.observability.cert_manager.operator.affinity
      nodeSelector = var.observability.cert_manager.operator.nodeSelector
      selector     = var.observability.cert_manager.operator.selector
      tolerations  = var.observability.cert_manager.operator.tolerations
      resources    = var.observability.cert_manager.operator.resources
    }
    env = [
      {
        name  = "ARGS"
        value = "-v=10"
      },
    ]
  }

  depends_on = [
    module.global-operator-group,
  ]
}

variable "loki_name" {
  type    = string
  default = "loki"
}

#resource "minio_bucket" "loki" {
#  name = var.loki_name
#}

resource "kubernetes_secret" "loki-s3-credentials" {
  metadata {
    namespace = kubernetes_namespace.observability.metadata.0.name
    name      = "${var.loki_name}-s3-creds"
  }

  data = {
    bucketnames       = var.loki_name
    endpoint          = local.s3.endpoint
    access_key_id     = local.s3.access_key_id
    access_key_secret = local.s3.secret_access_key
    region            = local.region
  }

  depends_on = [
    #    minio_bucket.loki,
  ]
}

module "loki" {
  source = "../../modules/olm/loki/crd"

  kind = "LokiStack"

  metadata = {
    namespace = kubernetes_namespace.observability.metadata.0.name
    name      = var.loki_name
  }

  spec = {
    size    = "1x.extra-small"
    storage = {
      secret = {
        type = "s3"
        name = kubernetes_secret.loki-s3-credentials.metadata.0.name
      }
    }
    storageClassName = "standard"
  }

  depends_on = [
    kubernetes_namespace.observability,
    module.loki-operator,
    kubernetes_secret.loki-s3-credentials,
  ]
}

#module "loki-virtual-service" {
#  source    = "../../modules/istio/virtual-service"
#  namespace = {
#    create = false
#    name   = module.istio-operator.namespace.name
#  }
#  name = "loki-vs"
#  spec = {
#    gateways = [
#      module.northsouth-gateway.name,
#      module.eastwest-gateway.name,
#    ]
#    hosts = [
#      "loki.${var.istio.ingress_gateways.north_south.domain}",
#    ]
#    http = [
#      {
#        match = [
#          {
#            uri = {
#              prefix = "/loki"
#            }
#          },
#        ]
#        route = [
#          {
#            destination = {
#              host = "loki"
#              port = {
#                number = 3100
#              }
#            }
#          },
#        ]
#      },
#    ]
#  }
#  depends_on = [
#    module.northsouth-gateway,
#    module.eastwest-gateway,
#  ]
#}

# -----------------------------------------------------PROMETHEUS-------------------------------------------------------
module "prometheus-operator" {
  source = "../../modules/olm/crd/v1alpha1"

  kind = "Subscription"

  metadata = {
    namespace = module.observability-operator-group.metadata.namespace
    name      = "prometheus-operator"
  }

  spec = {
    channel         = "beta"
    name            = "prometheus"
    source          = "operatorhubio-catalog"
    sourceNamespace = module.olm.namespace.metadata.name
    config          = {
      affinity     = var.observability.cert_manager.operator.affinity
      nodeSelector = var.observability.cert_manager.operator.nodeSelector
      selector     = var.observability.cert_manager.operator.selector
      tolerations  = var.observability.cert_manager.operator.tolerations
      resources    = var.observability.cert_manager.operator.resources
    }
    env = [
      {
        name  = "ARGS"
        value = "-v=10"
      },
    ]
  }

  depends_on = [
    module.observability-operator-group,
  ]
}

module "prometheus" {
  source = "../../modules/olm/prometheus/crd"

  kind = "Prometheus"

  metadata = {
    namespace = kubernetes_namespace.observability.metadata.0.name
    name      = "prometheus"
  }

  spec = {
    image : "prom/prometheus:v2.44.0"
    replicas = 1
    alerting = {
      alertmanagers = [
        {
          name      = "alertmanager-main"
          namespace = "monitoring"
          port      = "web"
        },
      ]
    }
  }

  depends_on = [
    kubernetes_namespace.observability,
    module.prometheus-operator,
  ]
}

#module "prometheus-virtual-service" {
#  source    = "../../modules/istio/virtual-service"
#  namespace = {
#    create = false
#    name   = module.istio.namespace.name
#  }
#  name = "prometheus-vs"
#  spec = {
#    gateways = [
#      module.northsouth-gateway.name,
#      module.eastwest-gateway.name,
#    ]
#    hosts = [
#      "*",
#    ]
#    http = [
#      {
#        name  = "prometheus"
#        match = [
#          {
#            uri = {
#              prefix = "/prometheus/"
#            }
#          },
#        ]
#        route = [
#          {
#            destination = {
#              host = "prometheus-operated.${kubernetes_namespace.observability.metadata.0.name}.svc.cluster.local"
#              port = {
#                number = 9090
#              }
#            }
#          },
#        ]
#      },
#    ]
#  }
#  depends_on = [
#    module.northsouth-gateway,
#    module.eastwest-gateway,
#    module.prometheus
#  ]
#}

# ------------------------------------------------------GRAFANA---------------------------------------------------------
module "grafana-operator" {
  source = "../../modules/olm/crd/v1alpha1"

  kind = "Subscription"

  metadata = {
    namespace = module.observability-operator-group.metadata.namespace
    name      = "grafana-operator"
  }

  spec = {
    channel         = "v5"
    name            = "grafana-operator"
    source          = "operatorhubio-catalog"
    sourceNamespace = module.olm.namespace.metadata.name
    config          = {
      affinity     = var.observability.cert_manager.operator.affinity
      nodeSelector = var.observability.cert_manager.operator.nodeSelector
      selector     = var.observability.cert_manager.operator.selector
      tolerations  = var.observability.cert_manager.operator.tolerations
      resources    = var.observability.cert_manager.operator.resources
    }
    env = [
      {
        name  = "ARGS"
        value = "-v=10"
      },
    ]
  }

  depends_on = [
    module.observability-operator-group,
  ]
}

variable "grafana_name" {
  type    = string
  default = "grafana"
}

module "grafana" {
  source = "../../modules/olm/grafana/crd"

  kind = "Grafana"

  metadata = {
    namespace = kubernetes_namespace.observability.metadata.0.name
    labels    = {
      dashboards  = var.grafana_name
      datasources = var.grafana_name
      folders     = var.grafana_name
    }
    name = var.grafana_name
  }

  spec = {
    deployment = {
      template = {
        spec = {
          containers = [
            {
              name = "grafana"
              image : "grafana/grafana:10.0.0-ubuntu"
            },
          ]
        }
      }
    }
    config = {
      auth = {
        disable_login_form = false
      }
      security = {
        admin_password = "start"
        admin_user     = "root"
      }
      log = {
        mode = "console"
      }
    }
  }

  depends_on = [
    kubernetes_namespace.observability,
    module.grafana-operator,
  ]
}

module "grafana-dashboard" {
  for_each = fileset(path.module, "/files/grafana/dashboards/*.json")

  source = "../../modules/olm/grafana/crd"

  kind = "GrafanaDashboard"

  metadata = {
    namespace = kubernetes_namespace.observability.metadata.0.name
    name      = "grafana-dashboard-${trimsuffix(basename(each.value),".json")}"
  }

  spec = {
    instanceSelector = {
      matchLabels = {
        dashboards = var.grafana_name
      }
    }
    json = file("${path.module}/${each.value}")
  }

  depends_on = [
    module.grafana,
  ]
}

module "grafana-datasource" {
  source = "../../modules/olm/grafana/crd"

  kind = "GrafanaDataSource"

  metadata = {
    namespace = kubernetes_namespace.observability.metadata.0.name
    name      = "grafana-datasource"
  }

  spec = {
    name             = "grafana-datasource"
    instanceSelector = {
      matchLabels = {
        datasources = var.grafana_name
      }
    }
    datasources = jsondecode(file("${path.module}/files/grafana/datasources/datasources.json"))
    plugins     = [
      {
        name    = "grafana-clock-panel"
        version = "1.3.0"
      },
    ]
  }
  depends_on = [
    module.grafana,
  ]
}

module "grafana-folder" {
  for_each = fileset(path.module, "/files/grafana/folders/*.json")

  source = "../../modules/olm/grafana/crd"

  kind = "GrafanaFolder"

  metadata = {
    namespace = kubernetes_namespace.observability.metadata.0.name
    name      = "grafana-folder-${trimsuffix(basename(each.value),".json")}"
  }

  spec = {
    instanceSelector = {
      matchLabels = {
        folders = var.grafana_name
      }
    }
    json = file("${path.module}/${each.value}")
  }

  depends_on = [
    module.grafana,
  ]
}

#module "grafana-virtual-service" {
#  source    = "../../modules/istio/virtual-service"
#  namespace = {
#    create = false
#    name   = module.istio.namespace.name
#  }
#  name = "grafana-vs"
#  spec = {
#    gateways = [
#      module.northsouth-gateway.name,
#    ]
#    hosts = [
#      "*",
#    ]
#    http = [
#      {
#        name  = "grafana"
#        match = [
#          {
#            uri = {
#              prefix = "/grafana/"
#            }
#          },
#        ]
#        route = [
#          {
#            destination = {
#              host = "grafana-service.${kubernetes_namespace.observability.metadata.0.name}.svc.cluster.local"
#              port = {
#                number = 3000
#              }
#            }
#          },
#        ]
#      },
#    ]
#  }
#  depends_on = [
#    module.northsouth-gateway,
#    module.grafana
#  ]
#}

# -------------------------------------------------------KIALI----------------------------------------------------------
module "kiali-operator" {
  source = "../../modules/olm/crd/v1alpha1"

  kind = "Subscription"

  metadata = {
    namespace = module.global-operator-group.metadata.namespace
    name      = "kiali-operator"
  }

  spec = {
    channel         = "stable"
    name            = "kiali"
    source          = "operatorhubio-catalog"
    sourceNamespace = module.olm.namespace.metadata.name
    config          = {
      affinity     = var.observability.cert_manager.operator.affinity
      nodeSelector = var.observability.cert_manager.operator.nodeSelector
      selector     = var.observability.cert_manager.operator.selector
      tolerations  = var.observability.cert_manager.operator.tolerations
      resources    = var.observability.cert_manager.operator.resources
    }
    env = [
      {
        name  = "ARGS"
        value = "-v=10"
      },
    ]
  }

  depends_on = [
    module.global-operator-group,
  ]
}

module "kiali-anonymous" {
  source = "../../modules/olm/kiali/crd"

  kind = "Kiali"

  metadata = {
    namespace = kubernetes_namespace.observability.metadata.0.name
    name      = "kiali-anonymous"
  }

  spec = {
    # Kiali page title (browser title bar)
    installation_tag = "Kiali - View Only"
    istio_namespace  = kubernetes_namespace.network.metadata.0.name
    deployment       = {
      image_name : "quay.io/kiali/kiali:"
      image_pull_policy : "IfNotPresent"
      image_version : "v1.69"
      node_selector = var.observability.kiali.node_selector
      replicas      = var.observability.kiali.replicas
      hpa           = var.observability.kiali.autoscaling.enabled?{
        api_version = "autoscaling/v1"
        spec        = {
          minReplicas                    = var.observability.kiali.autoscaling.min_replicas
          maxReplicas                    = var.observability.kiali.autoscaling.max_replicas
          targetCPUUtilizationPercentage = var.observability.kiali.autoscaling.target_cpu_utilization_percentage
        }
      } : null
      instance_name         = "kiali-anonymous"
      accessible_namespaces = [
        "default",
        kubernetes_namespace.security.metadata.0.name,
        kubernetes_namespace.observability.metadata.0.name,
        kubernetes_namespace.compute.metadata.0.name,
      ]
      view_only_mode = true
      logger         = {
        log_format        = var.observability.kiali.log.format
        log_level         = var.observability.kiali.log.level
        sampler_rate      = var.observability.kiali.log.sampler_rate
        time_field_format = var.observability.kiali.log.time_field_format
      }
    }
    server = {
      web_root     = "/kiali-anonymous"
      # Use GZip compression for responses larger than 1400 bytes. You may want to disable
      # compression if you are exposing Kiali via a reverse proxy that is already
      # doing compression.
      gzip_enabled = false
      audit_log    = var.observability.kiali.audit_log
    }
    auth = {
      strategy = "anonymous"
    }
  }
  depends_on = [
    kubernetes_namespace.security,
    kubernetes_namespace.observability,
    kubernetes_namespace.compute,
    module.kiali-operator,
  ]
}

module "kiali-admin" {
  source = "../../modules/olm/kiali/crd"

  kind = "Kiali"

  metadata = {
    namespace = kubernetes_namespace.observability.metadata.0.name
    name      = "kiali-admin"
  }

  spec = {
    # Kiali page title (browser title bar)
    installation_tag = "Kiali - Admin"
    istio_namespace  = kubernetes_namespace.network.metadata.0.name
    deployment       = {
      image_name : "quay.io/kiali/kiali:"
      image_pull_policy : "IfNotPresent"
      image_version : "v1.69"
      node_selector = var.observability.kiali.node_selector
      replicas      = var.observability.kiali.replicas
      hpa           = var.observability.kiali.autoscaling.enabled?{
        api_version = "autoscaling/v1"
        spec        = {
          minReplicas                    = var.observability.kiali.autoscaling.min_replicas
          maxReplicas                    = var.observability.kiali.autoscaling.max_replicas
          targetCPUUtilizationPercentage = var.observability.kiali.autoscaling.target_cpu_utilization_percentage
        }
      } : null
      instance_name         = "kiali-admin"
      accessible_namespaces = [
        "default",
        kubernetes_namespace.security.metadata.0.name,
        kubernetes_namespace.observability.metadata.0.name,
        kubernetes_namespace.compute.metadata.0.name,
      ]
      view_only_mode = false
      logger         = {
        log_format        = var.observability.kiali.log.format
        log_level         = var.observability.kiali.log.level
        sampler_rate      = var.observability.kiali.log.sampler_rate
        time_field_format = var.observability.kiali.log.time_field_format
      }
    }
    server = {
      web_root     = "/kiali-admin"
      # Use GZip compression for responses larger than 1400 bytes. You may want to disable
      # compression if you are exposing Kiali via a reverse proxy that is already
      # doing compression.
      gzip_enabled = false
      audit_log    = var.observability.kiali.audit_log
    }
    auth = {
      strategy = "token"
    }
  }
  depends_on = [
    kubernetes_namespace.security,
    kubernetes_namespace.observability,
    kubernetes_namespace.compute,
    module.kiali-operator,
  ]
}

#module "kiali-admin-virtual-service" {
#  source    = "../../modules/istio/virtual-service"
#  namespace = {
#    create = false
#    name   = module.istio.namespace.name
#  }
#  name = "kiali-admin-vs"
#  spec = {
#    gateways = [
#      module.northsouth-gateway.name,
#    ]
#    http = [
#      {
#        headers = {
#          request = {
#            set = {
#              X-Forwarded-Port : "443"
#              # When using OpenID strategy for authentication and deploying Kiali behind a reverse proxy or a load balancer, Kiali needs to know the originating port of client requests. You may need to setup your proxy to inject a X-Forwarded-Port HTTP header when forwarding the request to Kiali.
#            }
#          }
#        }
#      },
#      {
#        name  = "kiali-admin"
#        match = [
#          {
#            uri = {
#              prefix = "/kiali-admin"
#            }
#          },
#        ]
#        rewrite = {
#          uri = "/kiali/"
#        }
#        route = [
#          {
#            destination = {
#              host = "kiali-admin"
#              port = {
#                number = 20001
#              }
#            }
#          },
#        ]
#      },
#    ]
#    hosts = [
#      "*",
#    ]
#  }
#  depends_on = [
#    module.northsouth-gateway,
#    module.kiali-admin,
#  ]
#}

#module "kiali-anonymous-virtual-service" {
#  source    = "../../modules/istio/virtual-service"
#  namespace = {
#    create = false
#    name   = module.istio.namespace.name
#  }
#  name = "kiali-anonymous-vs"
#  spec = {
#    gateways = [
#      module.eastwest-gateway.name,
#    ]
#    http = [
#      {
#        headers = {
#          request = {
#            set = {
#              X-Forwarded-Port : "443"
#              # When using OpenID strategy for authentication and deploying Kiali behind a reverse proxy or a load balancer, Kiali needs to know the originating port of client requests. You may need to setup your proxy to inject a X-Forwarded-Port HTTP header when forwarding the request to Kiali.
#            }
#          }
#        }
#      },
#      {
#        name  = "kiali-anonymous"
#        match = [
#          {
#            uri = {
#              prefix = "/kiali-anonymous"
#            }
#          },
#        ]
#        rewrite = {
#          uri = "/kiali/"
#        }
#        route = [
#          {
#            destination = {
#              host = "kiali-anonymous"
#              port = {
#                number = 20001
#              }
#            }
#          },
#        ]
#      },
#    ]
#    hosts = [
#      "*",
#    ]
#  }
#  depends_on = [
#    module.eastwest-gateway,
#    module.kiali-anonymous,
#  ]
#}

