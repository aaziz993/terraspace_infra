locals {
  crd = {
    apiVersion = "postgres-operator.crunchydata.com/v1beta1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}