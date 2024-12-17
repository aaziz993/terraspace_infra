locals {
  crd = {
    apiVersion = "acme.cert-manager.io/v1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}