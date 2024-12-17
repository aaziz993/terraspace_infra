locals {
  crd = {
    apiVersion = "redis.redis.opstreelabs.in/v1beta1"
    kind       = var.kind
    metadata   = var.metadata
    spec       = var.spec
  }
}