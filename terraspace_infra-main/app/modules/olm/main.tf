# This is where you put your resource declaration
resource "kubernetes_namespace" "olm" {
  count = var.namespace.create ? 1 : 0
  metadata {
    name        = var.namespace.metadata.name
    labels      = var.namespace.metadata.labels
    annotations = var.namespace.metadata.annotations
  }
}

resource "helm_release" "olm" {
  chart            = path.module
  version          = var.chart_version
  create_namespace = false
  namespace        = var.namespace.create ? kubernetes_namespace.olm.0.id : var.namespace.metadata.name
  name             = var.name

  dynamic "set" {
    for_each = var.additional_set
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }
}