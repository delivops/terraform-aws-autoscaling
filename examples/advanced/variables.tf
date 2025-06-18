variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "cluster_name" {
  description = "ECS cluster name where the services are running"
  type        = string
}

# High Priority Service Variables
variable "high_priority_service_name" {
  description = "High priority ECS service name"
  type        = string
}

variable "high_priority_queue_name" {
  description = "High priority SQS queue name"
  type        = string
}

