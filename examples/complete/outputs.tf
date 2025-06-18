output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "ecs_service_id" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.app.id
}

output "sqs_queue_url" {
  description = "URL of the SQS queue"
  value       = aws_sqs_queue.main.url
}

output "sqs_queue_arn" {
  description = "ARN of the SQS queue"
  value       = aws_sqs_queue.main.arn
}

output "sqs_dlq_url" {
  description = "URL of the SQS dead letter queue"
  value       = aws_sqs_queue.dlq.url
}

output "sqs_dlq_arn" {
  description = "ARN of the SQS dead letter queue"
  value       = aws_sqs_queue.dlq.arn
}

output "autoscaling_target_arn" {
  description = "ARN of the autoscaling target"
  value       = module.ecs_autoscaling.autoscaling_target_arn
}

output "scaling_alarms" {
  description = "Auto scaling alarm names"
  value = {
    scale_up   = module.ecs_autoscaling.age_scale_up_alarm_name
    scale_down = module.ecs_autoscaling.idle_scale_down_alarm_name
    emergency  = module.ecs_autoscaling.emergency_alarm_name
  }
}

output "log_groups" {
  description = "CloudWatch log group names"
  value = {
    ecs_cluster = aws_cloudwatch_log_group.ecs_cluster.name
    application = aws_cloudwatch_log_group.app.name
  }
}
