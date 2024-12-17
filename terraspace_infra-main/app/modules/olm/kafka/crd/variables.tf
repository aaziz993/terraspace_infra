# This is where you put your variables declaration
variable "kind" {
  type        = string
  description = "Module kind."
  validation {
    condition = contains([
      "Kafka", "KafkaConnect", "KafkaMirrorMaker", "KafkaBridge", "KafkaTopic", "KafkaUser", "KafkaConnector",
      "KafkaMirrorMaker2", "KafkaRebalance",
    ], var.kind)
    error_message = "Must be in 'Kafka', 'KafkaConnect', 'KafkaMirrorMaker', 'KafkaBridge', 'KafkaTopic', 'KafkaUser', 'KafkaConnector', 'KafkaMirrorMaker2', 'KafkaRebalance'."
  }
}

variable "metadata" {
  description = "Module metadata."
}

variable "spec" {
  description = "Module specification."
}