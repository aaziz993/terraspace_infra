locals {
  crd = {
    apiVersion = "integreatly.org/v1alpha1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}