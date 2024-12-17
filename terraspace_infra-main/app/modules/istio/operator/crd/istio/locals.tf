locals {
  crd = {
    apiVersion = "install.istio.io/v1alpha1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}