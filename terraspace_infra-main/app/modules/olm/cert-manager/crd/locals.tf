locals {
  crd = {
    apiVersion = "cert-manager.io/v1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}