# This is where you put your resource declaration
resource "kubectl_manifest" "crd" {
  validate_schema = false
  yaml_body       = yamlencode(local.crd)
}