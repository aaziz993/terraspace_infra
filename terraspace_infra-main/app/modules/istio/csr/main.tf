# This is where you put your resource declaration
resource "kubernetes_namespace" "istio-csr" {
  count    = var.namespace.create ? 1 : 0
  metadata {
    name        = var.namespace.metadata.name
    labels      = var.namespace.metadata.labels
    annotations = var.namespace.metadata.annotations
  }
}

resource "helm_release" "istio-csr" {
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager-istio-csr"
  version          = var.chart_version
  create_namespace = false
  namespace        = var.namespace.create ? kubernetes_namespace.istio-csr.0.id : var.namespace.metadata.name
  name             = var.name

  set {
    name  = "replicaCount"
    value = var.replica.count
  }

  set {
    name  = "app.certmanager.issuer.group"
    value = var.app.cert_manager.issuer.group
  }

  set {
    name  = "app.certmanager.issuer.kind"
    value = var.app.cert_manager.issuer.kind
  }

  set {
    name  = "app.certmanager.issuer.name"
    value = var.app.cert_manager.issuer.name
  }

  set {
    name  = "app.certmanager.namespace"
    value = var.app.cert_manager.namespace_name
  }

  set {
    name  = "app.controller.leaderElectionNamespace"
    value = var.app.controller.leader_election_namespace_name
  }

  set {
    name  = "app.istio.namespace"
    value = var.app.istio.namespace_name
  }

  set {
    name  = "app.tls.trustDomain"
    value = var.app.tls.trust_domain
  }

  set {
    name  = "app.tls.certificateDNSNames"
    value = "{${join(",", var.app.tls.certificate_dns_names)}}"
  }

  set {
    name  = "app.tls.rootCAFile"
    value = var.app.tls.root_ca.file
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
    var.volume_mounts==null?[] : [
      yamlencode({
        volumeMounts = var.volume_mounts
      })
    ],
    var.volumes==null?[] : [
      yamlencode({
        volumeMounts = var.volumes
      })
    ],
  ])
}