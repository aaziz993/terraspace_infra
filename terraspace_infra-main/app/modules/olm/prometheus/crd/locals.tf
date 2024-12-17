locals {
  crd = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}