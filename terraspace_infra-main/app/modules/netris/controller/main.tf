# This is where you put your resource declaration
resource "kubernetes_namespace" "netris-controller" {
  count    = var.namespace.create ? 1 : 0
  metadata {
    name        = var.namespace.metadata.name
    labels      = var.namespace.metadata.labels
    annotations = var.namespace.metadata.annotations
  }
}

resource "random_password" "password" {
  count  = var.netris.password==null?1 : 0
  length = 24
}

resource "random_password" "auth_key" {
  count  = var.netris.auth_key==null?1 : 0
  length = 24
}

resource "kubernetes_secret" "netris-controller" {
  metadata {
    name      = "web-service-frontend"
    namespace = var.namespace.metadata.name
  }

  data = {
    password = var.netris.password==null? random_password.password.0.result : var.netris.password
    auth_key = var.netris.auth_key==null? random_password.auth_key.0.result : var.netris.auth_key
  }
}

resource "helm_release" "netris-controller" {
  chart            = path.module
  create_namespace = false
  namespace        = var.namespace.create ? kubernetes_namespace.netris-controller.0.id : var.namespace.metadata.name
  name             = var.name

  set {
    name  = "netris.webLogin"
    value = var.netris.login
  }

  set {
    name  = "netris.webPassword"
    value = kubernetes_secret.netris-controller.data.password
  }

  set {
    name  = "netris.authKey"
    value = kubernetes_secret.netris-controller.data.auth_key
  }

  #    dynamic "set" {
  #      for_each = var.ingress!=null ? [
  #        var.ingress
  #      ] : []
  #      content {
  #        name  = "ingress.enabled"
  #        value = set.value["enabled"]
  #      }
  #    }
  #
  #    dynamic "set" {
  #      for_each = var.ingress!=null&&var.ingress["tls"]!=null ? [
  #        var.ingress["tls"]
  #      ] : []
  #      content {
  #        name  = "app.ingress.tls.secret_name"
  #        value = set.value["secret_name"]
  #      }
  #    }
  #
  #    dynamic "set" {
  #      for_each = var.ingress!=null&&var.ingress["tls"]!=null&&var.ingress["tls"]["hosts"]!=null ? [
  #        var.ingress["tls"]
  #      ] : []
  #      content {
  #        name  = "app.ingress.tls.hosts"
  #        value = set.value["hosts"]
  #      }
  #    }

  set {
    name  = "web-service-backend.replicaCount"
    value = var.web_service_backend.replicas
  }

  set {
    name  = "web-service-frontend.replicaCount"
    value = var.web_service_frontend.replicas
  }

  dynamic "set" {
    for_each = var.web_service_frontend.service!=null&&var.web_service_frontend.service["type"]!=null ? [
      var.web_service_frontend.service["type"]
    ] : []
    content {
      name  = "web-service-frontend.service.type"
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.web_service_frontend.service!=null&&var.web_service_frontend.service["node_port"]!=null ? [
      var.web_service_frontend.service["node_port"]
    ] : []
    content {
      name  = "web-service-frontend.service.nodePort"
      value = set.value
    }
  }

  set {
    name  = "grpc.replicaCount"
    value = var.grpc.replicas
  }

  set {
    name  = "telescope.replicaCount"
    value = var.telescope.replicas
  }

  set {
    name  = "telescope-notifier.replicaCount"
    value = var.telescope_notifier.replicas
  }

  set {
    name  = "web-session-generator.replicaCount"
    value = var.web_session_generator.replicas
  }

  set {
    name  = "equinix-metal-agent.enabled"
    value = var.equinix_metal_agent.enabled
  }

  set {
    name  = "phoenixnap-bmc-agent.enabled"
    value = var.phoenixnap_bmc_agent.enabled
  }

  set {
    name  = "haproxy.enabled"
    value = var.haproxy.enabled
  }

  dynamic "set" {
    for_each = var.additional_set
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }

  values = flatten([
    var.node_selector==null?[] : [
      yamlencode({
        nodeSelector = var.node_selector
      })
    ],
    var.resources==null?[] : [
      yamlencode({
        resources = var.resources
      })
    ],
    var.web_service_backend.autoscaling==null?[] : [
      yamlencode({
        web-service-backend = {
          autoscaling = var.web_service_backend.autoscaling
        }
      })
    ],
    var.web_service_frontend.autoscaling==null?[] : [
      yamlencode({
        web-service-frontend = {
          autoscaling = var.web_service_frontend.autoscaling
        }
      })
    ],
    var.grpc.autoscaling==null?[] : [
      yamlencode({
        grpc = {
          autoscaling = var.grpc.autoscaling
        }
      })
    ],
    var.telescope.autoscaling==null?[] : [
      yamlencode({
        telescope = {
          autoscaling = var.telescope.autoscaling
        }
      })
    ],
    var.telescope_notifier.autoscaling==null?[] : [
      yamlencode({
        telescope-notifier = {
          autoscaling = var.telescope_notifier.autoscaling
        }
      })
    ],
    var.web_session_generator.autoscaling==null?[] : [
      yamlencode({
        web-session-generator = {
          autoscaling = var.web_session_generator.autoscaling
        }
      })
    ],
  ])
}