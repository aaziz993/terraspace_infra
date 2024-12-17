# This is where you put your resource declaration
resource "kubernetes_namespace" "netris-operator" {
  count    = var.namespace.create ? 1 : 0
  metadata {
    name        = var.namespace.metadata.name
    labels      = var.namespace.metadata.labels
    annotations = var.namespace.metadata.annotations
  }
}

resource "helm_release" "netris-operator" {
  repository       = "https://netrisai.github.io/charts"
  chart            = "netris-operator"
  version          = var.chart_version
  create_namespace = false
  namespace        = var.namespace.create ? kubernetes_namespace.netris-operator.0.id : var.namespace.metadata.name
  name             = var.name

  set {
    name  = "controller.host"
    value = var.controller.host
  }

  set {
    name  = "controller.login"
    value = var.controller.login
  }

  set {
    name  = "controller.password"
    value = var.controller.password
  }

  set {
    name  = "controller.insecure"
    value = var.controller.insecure
  }

  set {
    name  = "controllerCreds.host.secretName"
    value = var.controller_creds.host.secret_name
  }

  set {
    name  = "controllerCreds.host.key"
    value = var.controller_creds.host.key
  }

  set {
    name  = "controllerCreds.login.secretName"
    value = var.controller_creds.login.secret_name
  }

  set {
    name  = "controllerCreds.login.key"
    value = var.controller_creds.login.key
  }

  set {
    name  = "controllerCreds.password.secretName"
    value = var.controller_creds.password.secret_name
  }

  set {
    name  = "controllerCreds.password.key"
    value = var.controller_creds.password.key
  }

  set {
    name  = "logLevel"
    value = var.log_level
  }

  set {
    name  = "requeueInterval"
    value = var.requeue_interval
  }

  set {
    name  = "calicoASNRange"
    value = var.calico_asn_range
  }

  set {
    name  = "l4lbTenant"
    value = var.l4lb_tenant
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
    ]
  ])
}