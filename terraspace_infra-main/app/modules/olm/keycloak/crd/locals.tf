locals {
  crd = {
    apiVersion = "k8s.keycloak.org/v2alpha1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}