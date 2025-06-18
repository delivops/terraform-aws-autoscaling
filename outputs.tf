output "autoscaling_target_resource_id" {
  description = "The resource ID of the autoscaling target"
  value       = aws_appautoscaling_target.ecs_target.resource_id
}

output "autoscaling_target_arn" {
  description = "The ARN of the autoscaling target"
  value       = aws_appautoscaling_target.ecs_target.arn
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = data.aws_sqs_queue.main.arn
}

output "queue_url" {
  description = "The URL of the SQS queue"
  value       = data.aws_sqs_queue.main.url
}

output "scale_up_policy_arn" {
  description = "The ARN of the scale up policy"
  value       = aws_appautoscaling_policy.scale_up_one.arn
}

output "scale_down_policy_arn" {
  description = "The ARN of the scale down policy"
  value       = aws_appautoscaling_policy.scale_down_one.arn
}

output "emergency_scale_up_policy_arn" {
  description = "The ARN of the emergency scale up policy"
  value       = aws_appautoscaling_policy.scale_up_emergency.arn
}

output "age_scale_up_alarm_name" {
  description = "The name of the age scale up alarm"
  value       = aws_cloudwatch_metric_alarm.age_scale_up.alarm_name
}

output "age_scale_up_alarm_arn" {
  description = "The ARN of the age scale up alarm"
  value       = aws_cloudwatch_metric_alarm.age_scale_up.arn
}

output "idle_scale_down_alarm_name" {
  description = "The name of the idle scale down alarm"
  value       = aws_cloudwatch_metric_alarm.empty_receives_scale_down.alarm_name
}

output "idle_scale_down_alarm_arn" {
  description = "The ARN of the idle scale down alarm"
  value       = aws_cloudwatch_metric_alarm.empty_receives_scale_down.arn
}

output "emergency_alarm_name" {
  description = "The name of the emergency scale up alarm"
  value       = aws_cloudwatch_metric_alarm.age_emergency.alarm_name
}

output "emergency_alarm_arn" {
  description = "The ARN of the emergency scale up alarm"
  value       = aws_cloudwatch_metric_alarm.age_emergency.arn
}
