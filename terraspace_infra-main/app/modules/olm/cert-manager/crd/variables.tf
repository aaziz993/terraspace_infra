# This is where you put your variables declaration
variable "kind" {
  type        = string
  description = "Module kind."
  validation {
    condition = contains([
      "CertificateRequest", "Certificate", "ClusterIssuer", "Issuer",
    ], var.kind)
    error_message = "Must be in 'CertificateRequest', 'Certificate', 'ClusterIssuer', 'Issuer'."
  }
}

variable "metadata" {
  description = "Module metadata."
}

variable "spec" {
  description = "Module specification."
}