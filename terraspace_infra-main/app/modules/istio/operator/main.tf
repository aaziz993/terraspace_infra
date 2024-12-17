# This is where you put your resource declaration
resource "kubernetes_namespace" "istio-operator" {
  count = var.namespace.create ? 1 : 0
  metadata {
    name        = var.namespace.metadata.name
    labels      = var.namespace.metadata.labels
    annotations = var.namespace.metadata.annotations
  }
}

resource "helm_release" "istio-operator" {
  chart            = path.module
  create_namespace = false
  namespace        = var.namespace.create ? kubernetes_namespace.istio-operator.0.id : var.namespace.metadata.name
  name             = var.name

  set {
    name  = "hub"
    value = var.hub
  }

  set {
    name  = "tag"
    value = var.tag
  }

  set {
    name  = "revision"
    value = var.revision
  }

  set {
    name  = "replicaCount"
    value = var.replicas
  }

  set {
    name  = "watchedNamespaces"
    value = join(",", var.watch_namespaces)
  }

  set {
    name  = "enableCRDTemplates"
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
    var.node_selector==null?[] : [
      yamlencode({
        nodeSelector = var.node_selector
      })
    ],
    var.resources==null?[] : [
      yamlencode({
        operator = {
          resources = var.resources
        }
      })
    ]
  ])
}