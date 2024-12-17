locals {
  crd = {
    apiVersion = "jaegertracing.io/v1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}