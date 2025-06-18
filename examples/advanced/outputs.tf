output "high_priority_autoscaling_target_arn" {
  description = "The ARN of the high priority autoscaling target"
  value       = module.high_priority_autoscaling.autoscaling_target_arn
}

output "high_priority_alarms" {
  description = "High priority service alarm names"
  value = {
    scale_up   = module.high_priority_autoscaling.age_scale_up_alarm_name
    scale_down = module.high_priority_autoscaling.idle_scale_down_alarm_name
    emergency  = module.high_priority_autoscaling.emergency_alarm_name
  }
}


