locals {
  crd = {
    apiVersion = "monitoring.coreos.com/v1alpha1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}