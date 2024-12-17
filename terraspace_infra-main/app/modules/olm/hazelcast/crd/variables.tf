# This is where you put your variables declaration
variable "kind" {
  type        = string
  description = "Module kind."
  validation {
    condition = contains([
      "Cache", "CronHotBackup", "Hazelcast", "HotBackup", "ManagementCenter", "Map", "MultiMap", "Queue",
      "ReplicatedMap", "Topic", "WanReplication",
    ], var.kind)
    error_message = "Must be in 'Cache', 'CronHotBackup' ,'Hazelcast' ,'HotBackup' ,'ManagementCenter' ,'Map' ,'MultiMap' ,'Queue' ,'ReplicatedMap' ,'Topic' ,'WanReplication'."
  }
}

variable "metadata" {
  description = "Module metadata."
}

variable "spec" {
  description = "Module specification."
}