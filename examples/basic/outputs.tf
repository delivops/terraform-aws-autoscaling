output "autoscaling_target_arn" {
  description = "The ARN of the autoscaling target"
  value       = module.ecs_autoscaling.autoscaling_target_arn
}

output "scale_up_alarm_name" {
  description = "The name of the scale up alarm"
  value       = module.ecs_autoscaling.age_scale_up_alarm_name
}

output "scale_down_alarm_name" {
  description = "The name of the scale down alarm"
  value       = module.ecs_autoscaling.idle_scale_down_alarm_name
}

output "emergency_alarm_name" {
  description = "The name of the emergency scale up alarm"
  value       = module.ecs_autoscaling.emergency_alarm_name
}
