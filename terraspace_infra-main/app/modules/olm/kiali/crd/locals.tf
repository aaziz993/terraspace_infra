locals {
  crd = {
    apiVersion = "kiali.io/v1alpha1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}