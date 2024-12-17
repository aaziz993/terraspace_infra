locals {
  crd = {
    apiVersion = "trust.cert-manager.io/v1alpha1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}