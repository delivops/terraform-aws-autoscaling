# Terraform AWS ECS Auto Scaling Module

A Terraform module that provides intelligent auto scaling for ECS services based on Amazon SQS queue metrics. This module implements a smart scaling strategy with normal scaling and emergency scaling capabilities.

## Features

- **SQS-based Auto Scaling**: Scale ECS tasks based on SQS queue message age and visibility
- **Smart Scaling Strategy**:
  - Normal scaling: +1/-1 tasks based on message age
  - Emergency scaling: +5 tasks when messages are critically old
  - Intelligent scale-down: Only scale down when queue is truly idle
- **Configurable Thresholds**: Customize all scaling parameters
- **Circuit Breaker Pattern**: Emergency scaling prevents SLA breaches
- **CloudWatch Integration**: Full monitoring with custom alarms

## Scaling Logic

### Scale Up (+1 task)

- Triggers when the oldest message age > `age_threshold_normal` (default: 3 minutes)
- Cooldown: 1 minute between scale-ups
- Prevents gradual queue buildup

### Scale Down (-1 task)

- Triggers when both conditions are met:
  - Visible messages < `scale_down_visible_messages_threshold` (default: 10)
  - Oldest message age < `scale_down_age_threshold` (default: 30 seconds)
- Cooldown: 5 minutes between scale-downs
- Prevents premature scaling down

### Emergency Scale Up (+5 tasks)

- Triggers when oldest message age > `age_threshold_emergency` (default: 4 minutes)
- Cooldown: 2 minutes between emergency scales
- Circuit breaker for SLA protection

## Usage

```hcl
module "ecs_autoscaling" {
  source = "./path-to-this-module"

  cluster_name = "my-ecs-cluster"
  service_name = "my-worker-service"
  queue_name   = "my-processing-queue"

  # Scaling limits
  min_capacity = 1
  max_capacity = 20

  # Scaling thresholds (in seconds)
  age_threshold_normal    = 180  # 3 minutes
  age_threshold_emergency = 300  # 5 minutes

  # Scale down criteria
  scale_down_visible_messages_threshold = 5
  scale_down_age_threshold             = 60

  tags = {
    Environment = "production"
    Service     = "message-processor"
  }
}
```

## Examples

See the [examples](./examples/) directory for complete usage examples:

- [Basic Usage](./examples/basic/) - Simple setup with default values
- [Advanced Configuration](./examples/advanced/) - Custom thresholds and settings
- [Complete Infrastructure](./examples/complete/) - Full ECS cluster with SQS and scaling

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= 1.0  |
| aws       | >= 5.0  |

## Providers

| Name | Version |
| ---- | ------- |
| aws  | >= 5.0  |

## Resources

This module creates the following resources:

- `aws_appautoscaling_target` - ECS service scaling target
- `aws_appautoscaling_policy` (3x) - Scale up, scale down, and emergency policies
- `aws_cloudwatch_metric_alarm` (3x) - Monitoring alarms for scaling triggers

## Inputs

| Name                                  | Description                                                          | Type          | Default | Required |
| ------------------------------------- | -------------------------------------------------------------------- | ------------- | ------- | :------: |
| cluster_name                          | ECS cluster name where the service is running                        | `string`      | n/a     |   yes    |
| service_name                          | ECS service name                                                     | `string`      | n/a     |   yes    |
| queue_name                            | SQS queue name                                                       | `string`      | n/a     |   yes    |
| max_capacity                          | Maximum number of tasks                                              | `number`      | `50`    |    no    |
| min_capacity                          | Minimum number of tasks                                              | `number`      | `0`     |    no    |
| age_threshold_normal                  | Age in seconds to trigger +1 scaling                                 | `number`      | `180`   |    no    |
| age_threshold_emergency               | Age in seconds to trigger emergency scaling                          | `number`      | `240`   |    no    |
| scale_up_cooldown                     | Cooldown period in seconds between scale up actions                  | `number`      | `60`    |    no    |
| scale_down_cooldown                   | Cooldown period in seconds between scale down actions                | `number`      | `300`   |    no    |
| emergency_cooldown                    | Cooldown period in seconds between emergency scale up actions        | `number`      | `120`   |    no    |
| emergency_scale_adjustment            | Number of tasks to add during emergency scaling                      | `number`      | `5`     |    no    |
| scale_down_visible_messages_threshold | Maximum number of visible messages before preventing scale down      | `number`      | `10`    |    no    |
| scale_down_age_threshold              | Maximum age of oldest message (seconds) before preventing scale down | `number`      | `30`    |    no    |
| scale_down_evaluation_periods         | Number of evaluation periods for scale down alarm                    | `number`      | `5`     |    no    |
| tags                                  | A map of tags to assign to the resources                             | `map(string)` | `{}`    |    no    |

## Outputs

| Name                           | Description                               |
| ------------------------------ | ----------------------------------------- |
| autoscaling_target_resource_id | The resource ID of the autoscaling target |
| autoscaling_target_arn         | The ARN of the autoscaling target         |
| queue_arn                      | The ARN of the SQS queue                  |
| queue_url                      | The URL of the SQS queue                  |
| scale_up_policy_arn            | The ARN of the scale up policy            |
| scale_down_policy_arn          | The ARN of the scale down policy          |
| emergency_scale_up_policy_arn  | The ARN of the emergency scale up policy  |
| age_scale_up_alarm_name        | The name of the age scale up alarm        |
| age_scale_up_alarm_arn         | The ARN of the age scale up alarm         |
| idle_scale_down_alarm_name     | The name of the idle scale down alarm     |
| idle_scale_down_alarm_arn      | The ARN of the idle scale down alarm      |
| emergency_alarm_name           | The name of the emergency scale up alarm  |
| emergency_alarm_arn            | The ARN of the emergency scale up alarm   |

## Monitoring

The module creates CloudWatch alarms that you can monitor:

1. **Age Scale Up Alarm**: `{service_name}-age-scale-up`
2. **Idle Scale Down Alarm**: `{service_name}-idle-scale-down`
3. **Emergency Scale Up Alarm**: `{service_name}-age-emergency`

## Best Practices

1. **Queue Visibility Timeout**: Ensure your SQS queue's visibility timeout is longer than your task processing time
2. **Dead Letter Queue**: Configure a DLQ for failed messages
3. **Monitoring**: Set up CloudWatch dashboards to monitor scaling events
4. **Testing**: Test scaling behavior in a non-production environment first
5. **Capacity Planning**: Set appropriate min/max capacity based on your workload

## Cost Optimization

- Use appropriate cooldown periods to prevent excessive scaling events
- Monitor CloudWatch costs as this module creates several alarms
- Consider using spot instances for batch processing workloads
- Set reasonable max_capacity to prevent runaway scaling costs

## Troubleshooting

### Common Issues

1. **No scaling events**: Check that the ECS service name and cluster name are correct
2. **Too frequent scaling**: Increase cooldown periods
3. **Slow response to load**: Decrease age thresholds or cooldown periods
4. **Tasks not scaling down**: Check scale-down thresholds and ensure queue is truly idle

### Debugging

Check CloudWatch metrics for your SQS queue:

- `ApproximateAgeOfOldestMessage`
- `ApproximateNumberOfMessagesVisible`
- `ApproximateNumberOfMessagesNotVisible`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests and examples
5. Submit a pull request

## License

This module is licensed under the MIT License. See [LICENSE](LICENSE) for full details.

## Authors

Created and maintained by the DelivOps team.

## Support

For questions or issues, please open a GitHub issue or contact the maintainers.
