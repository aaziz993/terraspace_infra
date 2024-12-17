locals {
  crd = {
    apiVersion = "loki.grafana.com/v1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}