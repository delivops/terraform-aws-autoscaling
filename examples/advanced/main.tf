terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# High-priority processing service with aggressive scaling
module "high_priority_autoscaling" {
  source = "../../"

  cluster_name = var.cluster_name
  service_name = var.high_priority_service_name
  queue_name   = var.high_priority_queue_name

  # Capacity limits
  min_capacity = 2
  max_capacity = 50

  # Aggressive scaling thresholds
  age_threshold_normal    = 120 # 2 minutes
  age_threshold_emergency = 180 # 3 minutes

  # Faster response times
  scale_up_cooldown  = 30 # 30 seconds
  emergency_cooldown = 60 # 1 minute

  # More aggressive emergency scaling
  emergency_scale_adjustment = 10

  # Aggressive scale down for cost optimization
  scale_down_visible_messages_threshold = 5
  scale_down_age_threshold              = 15
  scale_down_cooldown                   = 180 # 3 minutes

  tags = {
    Environment = var.environment
    Service     = "high-priority-processor"
    Priority    = "high"
    ManagedBy   = "terraform"
  }
}
