# This is where you put your resource declaration
resource "kubernetes_namespace" "trust-manager" {
  count    = var.namespace.create ? 1 : 0
  metadata {
    name        = var.namespace.metadata.name
    labels      = var.namespace.metadata.labels
    annotations = var.namespace.metadata.annotations
  }
}

resource "helm_release" "trust-manager" {
  repository       = "https://charts.jetstack.io"
  chart            = "trust-manager"
  version          = var.chart_version
  create_namespace = false
  namespace        = var.namespace.create ? kubernetes_namespace.trust-manager.0.id : var.namespace.metadata.name
  name             = var.name

  set {
    name  = "replicaCount"
    value = var.replicas
  }

  set {
    name  = "app.trust.namespace"
    value = var.app.trust.namespace_name
  }

  set {
    name  = "app.logLevel"
    value = var.app.log_level
  }

  set {
    name  = "crds.enabled"
    value = var.crds.enabled
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
    var.resources==null?[] : [
      yamlencode({
        resources = var.resources
      })
    ]
  ])
}