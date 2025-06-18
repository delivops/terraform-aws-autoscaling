variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "ecs-autoscaling-demo"
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "single_nat_gateway" {
  description = "Use single NAT gateway to reduce costs"
  type        = bool
  default     = true
}

# ECS Configuration
variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "message-processing-cluster"
}

variable "service_name" {
  description = "ECS service name"
  type        = string
  default     = "message-processor"
}

variable "container_image" {
  description = "Container image for the worker task"
  type        = string
  default     = "nginx:latest" # Replace with your actual worker image
}

variable "task_cpu" {
  description = "CPU units for the task (1024 = 1 vCPU)"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory (MiB) for the task"
  type        = number
  default     = 512
}

variable "initial_desired_count" {
  description = "Initial desired count for ECS service"
  type        = number
  default     = 1
}

# SQS Configuration
variable "queue_name" {
  description = "SQS queue name"
  type        = string
  default     = "message-processing-queue"
}

variable "message_visibility_timeout" {
  description = "SQS message visibility timeout in seconds"
  type        = number
  default     = 300 # 5 minutes
}

variable "max_receive_count" {
  description = "Maximum receive count before sending to DLQ"
  type        = number
  default     = 3
}

# Auto Scaling Configuration
variable "min_capacity" {
  description = "Minimum number of tasks"
  type        = number
  default     = 0
}

variable "max_capacity" {
  description = "Maximum number of tasks"
  type        = number
  default     = 10
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
