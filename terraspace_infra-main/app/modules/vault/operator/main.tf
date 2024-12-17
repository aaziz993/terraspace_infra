# This is where you put your resource declaration
resource "kubernetes_namespace" "vault-operator" {
  count = var.namespace.create ? 1 : 0

  metadata {
    name        = var.namespace.metadata.name
    annotations = var.namespace.metadata.annotations
    labels      = var.namespace.metadata.labels
  }
}

resource "helm_release" "vault-operator" {
  repository       = "https://kubernetes-charts.banzaicloud.com"
  chart            = "vault-operator"
  version          = var.chart_version
  create_namespace = false
  namespace        = var.namespace.create ? kubernetes_namespace.vault-operator.0.id : var.namespace.metadata.name
  name             = var.name

  set {
    name  = "replicaCount"
    value = var.replicas
  }

  set {
    name  = "watchNamespace"
    value = join(",", var.watch_namespaces)
  }

  set {
    name  = "syncPeriod"
    value = var.sync_period
  }

  set {
    name  = "psp.enabled"
    value = var.psp.enabled
  }

  set {
    name  = "psp.vaultSA"
    value = var.psp.vault_sa
  }

  values = flatten([
    var.affinity==null?[] : [
      yamlencode({
        affinity = var.affinity
      })
    ],
    var.tolerations==null?[] : [
      yamlencode({
        tolerations = var.tolerations
      })
    ],
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
    var.crd_annotations==null?[] : [
      yamlencode({
        crdAnnotations = var.crd_annotations
      })
    ],
  ])
}