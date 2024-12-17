# This is where you put your variables declaration
variable "kind" {
  type        = string
  description = "Module kind."
  validation {
    condition = contains([
      "RedisCluster", "Redis",
    ], var.kind)
    error_message = "Must be in 'RedisCluster', 'Redis'."
  }
}

variable "metadata" {
  description = "Module metadata."
}

variable "spec" {
  description = "Module specification."
}