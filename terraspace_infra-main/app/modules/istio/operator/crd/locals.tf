locals {
  crd = {
    apiVersion = "networking.istio.io/v1beta1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}