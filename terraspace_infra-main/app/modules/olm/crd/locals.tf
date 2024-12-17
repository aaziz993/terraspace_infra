locals {
  crd = {
    apiVersion = "operators.coreos.com/v1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}