variable "cluster_name" {
  description = "ECS cluster name where the service is running"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
  type        = string
}

variable "queue_name" {
  description = "SQS queue name"
  type        = string
}

variable "max_capacity" {
  description = "Maximum number of tasks"
  type        = number
  default     = 50
}

variable "min_capacity" {
  description = "Minimum number of tasks"
  type        = number
  default     = 0
}

variable "age_threshold_normal" {
  description = "Age in seconds to trigger +1 scaling"
  type        = number
  default     = 180 # 3 minutes
}

variable "age_threshold_emergency" {
  description = "Age in seconds to trigger emergency scaling"
  type        = number
  default     = 240 # 4 minutes
}

variable "empty_receives_per_task" {
  description = "Number of empty receives per task before scaling down"
  type        = number
  default     = 10
}

variable "scale_up_cooldown" {
  description = "Cooldown period in seconds between scale up actions"
  type        = number
  default     = 60
}

variable "scale_down_cooldown" {
  description = "Cooldown period in seconds between scale down actions"
  type        = number
  default     = 300
}

variable "emergency_cooldown" {
  description = "Cooldown period in seconds between emergency scale up actions"
  type        = number
  default     = 120
}

variable "emergency_scale_adjustment" {
  description = "Number of tasks to add during emergency scaling"
  type        = number
  default     = 5
}

variable "scale_down_visible_messages_threshold" {
  description = "Maximum number of visible messages before preventing scale down"
  type        = number
  default     = 10
}

variable "scale_down_age_threshold" {
  description = "Maximum age of oldest message (seconds) before preventing scale down"
  type        = number
  default     = 30
}

variable "scale_down_evaluation_periods" {
  description = "Number of evaluation periods for scale down alarm"
  type        = number
  default     = 5
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
