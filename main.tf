# ECS Auto Scaling Module
# Simple ECS Worker Autoscaling based on SQS metrics
# Strategy: +1/-1 scaling with emergency circuit breaker

# Get SQS queue information
data "aws_sqs_queue" "main" {
  name = var.queue_name
}

# ECS Autoscaling Target
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# SCALE UP: Age of oldest message > threshold
resource "aws_cloudwatch_metric_alarm" "age_scale_up" {
  alarm_name          = "${var.service_name}-age-scale-up"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.age_threshold_normal
  alarm_description   = "Scale up by 1 when messages are aging"
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = var.queue_name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_up_one.arn]

  tags = var.tags
}

# SCALE UP POLICY: +1 task
resource "aws_appautoscaling_policy" "scale_up_one" {
  name               = "${var.service_name}-scale-up-one"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_up_cooldown
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

# SCALE DOWN: Too many empty receives with low queue activity
resource "aws_cloudwatch_metric_alarm" "empty_receives_scale_down" {
  alarm_name          = "${var.service_name}-idle-scale-down"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.scale_down_evaluation_periods
  threshold           = 1
  alarm_description   = "Scale down when idle - few visible messages AND no old messages"
  treat_missing_data  = "notBreaching"
  datapoints_to_alarm = var.scale_down_evaluation_periods

  # Scale down if: few visible messages AND no old messages
  metric_query {
    id          = "should_scale_down"
    expression  = "IF(visible < ${var.scale_down_visible_messages_threshold} AND age < ${var.scale_down_age_threshold}, 1, 0)"
    label       = "Should scale down"
    return_data = true
  }

  metric_query {
    id = "visible"
    metric {
      metric_name = "ApproximateNumberOfMessagesVisible"
      namespace   = "AWS/SQS"
      period      = "60"
      stat        = "Average"
      dimensions = {
        QueueName = var.queue_name
      }
    }
  }

  metric_query {
    id = "age"
    metric {
      metric_name = "ApproximateAgeOfOldestMessage"
      namespace   = "AWS/SQS"
      period      = "60"
      stat        = "Maximum"
      dimensions = {
        QueueName = var.queue_name
      }
    }
  }

  alarm_actions = [aws_appautoscaling_policy.scale_down_one.arn]

  tags = var.tags
}

# SCALE DOWN POLICY: -1 task
resource "aws_appautoscaling_policy" "scale_down_one" {
  name               = "${var.service_name}-scale-down-one"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_down_cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

# EMERGENCY SCALE UP: Age critically high
resource "aws_cloudwatch_metric_alarm" "age_emergency" {
  alarm_name          = "${var.service_name}-age-emergency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.age_threshold_emergency
  alarm_description   = "Emergency scale up when approaching SLO"
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = var.queue_name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_up_emergency.arn]

  tags = var.tags
}

# EMERGENCY SCALE UP POLICY: +5 tasks
resource "aws_appautoscaling_policy" "scale_up_emergency" {
  name               = "${var.service_name}-scale-up-emergency"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.emergency_cooldown
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = var.emergency_scale_adjustment
    }
  }
}


