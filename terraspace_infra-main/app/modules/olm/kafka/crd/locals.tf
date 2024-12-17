locals {
  crd = {
    apiVersion = "kafka.strimzi.io/v1beta2"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}