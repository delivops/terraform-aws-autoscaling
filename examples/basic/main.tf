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

module "ecs_autoscaling" {
  source = "../../"

  cluster_name = var.cluster_name
  service_name = var.service_name
  queue_name   = var.queue_name

  min_capacity = var.min_capacity
  max_capacity = var.max_capacity

  tags = {
    Environment = "development"
    Example     = "basic"
    ManagedBy   = "terraform"
  }
}
