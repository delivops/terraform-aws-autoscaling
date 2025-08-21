[![DelivOps banner](https://raw.githubusercontent.com/delivops/.github/main/images/banner.png?raw=true)](https://delivops.com)

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
  source = "xxx"

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

## Monitoring

The module creates CloudWatch alarms that you can monitor:

1. **Age Scale Up Alarm**: `{cluster_name}/{service_name}-age-scale-up`
2. **Idle Scale Down Alarm**: `{cluster_name}/{service_name}-idle-scale-down`
3. **Emergency Scale Up Alarm**: `{cluster_name}/{service_name}-age-emergency`

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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.scale_down_one](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.scale_up_emergency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.scale_up_one](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_metric_alarm.age_emergency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.age_scale_up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.empty_receives_scale_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sqs_queue.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sqs_queue) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_age_threshold_emergency"></a> [age\_threshold\_emergency](#input\_age\_threshold\_emergency) | Age in seconds to trigger emergency scaling | `number` | `240` | no |
| <a name="input_age_threshold_normal"></a> [age\_threshold\_normal](#input\_age\_threshold\_normal) | Age in seconds to trigger +1 scaling | `number` | `180` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | ECS cluster name where the service is running | `string` | n/a | yes |
| <a name="input_emergency_cooldown"></a> [emergency\_cooldown](#input\_emergency\_cooldown) | Cooldown period in seconds between emergency scale up actions | `number` | `120` | no |
| <a name="input_emergency_datapoints_to_alarm"></a> [emergency\_datapoints\_to\_alarm](#input\_emergency\_datapoints\_to\_alarm) | Number of datapoints that must be breaching to trigger emergency scale up alarm | `number` | `1` | no |
| <a name="input_emergency_evaluation_periods"></a> [emergency\_evaluation\_periods](#input\_emergency\_evaluation\_periods) | Number of evaluation periods for emergency scale up alarm | `number` | `1` | no |
| <a name="input_emergency_scale_adjustment"></a> [emergency\_scale\_adjustment](#input\_emergency\_scale\_adjustment) | Number of tasks to add during emergency scaling | `number` | `5` | no |
| <a name="input_empty_receives_per_task"></a> [empty\_receives\_per\_task](#input\_empty\_receives\_per\_task) | Number of empty receives per task before scaling down | `number` | `10` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Maximum number of tasks | `number` | `50` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Minimum number of tasks | `number` | `0` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | SQS queue name | `string` | n/a | yes |
| <a name="input_scale_down_age_threshold"></a> [scale\_down\_age\_threshold](#input\_scale\_down\_age\_threshold) | Maximum age of oldest message (seconds) before preventing scale down | `number` | `30` | no |
| <a name="input_scale_down_cooldown"></a> [scale\_down\_cooldown](#input\_scale\_down\_cooldown) | Cooldown period in seconds between scale down actions | `number` | `300` | no |
| <a name="input_scale_down_datapoints_to_alarm"></a> [scale\_down\_datapoints\_to\_alarm](#input\_scale\_down\_datapoints\_to\_alarm) | Number of datapoints that must be breaching to trigger scale down alarm | `number` | `5` | no |
| <a name="input_scale_down_evaluation_periods"></a> [scale\_down\_evaluation\_periods](#input\_scale\_down\_evaluation\_periods) | Number of evaluation periods for scale down alarm | `number` | `5` | no |
| <a name="input_scale_down_visible_messages_threshold"></a> [scale\_down\_visible\_messages\_threshold](#input\_scale\_down\_visible\_messages\_threshold) | Maximum number of visible messages before preventing scale down | `number` | `10` | no |
| <a name="input_scale_up_cooldown"></a> [scale\_up\_cooldown](#input\_scale\_up\_cooldown) | Cooldown period in seconds between scale up actions | `number` | `60` | no |
| <a name="input_scale_up_datapoints_to_alarm"></a> [scale\_up\_datapoints\_to\_alarm](#input\_scale\_up\_datapoints\_to\_alarm) | Number of datapoints that must be breaching to trigger normal scale up alarm | `number` | `1` | no |
| <a name="input_scale_up_evaluation_periods"></a> [scale\_up\_evaluation\_periods](#input\_scale\_up\_evaluation\_periods) | Number of evaluation periods for normal scale up alarm | `number` | `1` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | ECS service name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_age_scale_up_alarm_arn"></a> [age\_scale\_up\_alarm\_arn](#output\_age\_scale\_up\_alarm\_arn) | The ARN of the age scale up alarm |
| <a name="output_age_scale_up_alarm_name"></a> [age\_scale\_up\_alarm\_name](#output\_age\_scale\_up\_alarm\_name) | The name of the age scale up alarm |
| <a name="output_autoscaling_target_arn"></a> [autoscaling\_target\_arn](#output\_autoscaling\_target\_arn) | The ARN of the autoscaling target |
| <a name="output_autoscaling_target_resource_id"></a> [autoscaling\_target\_resource\_id](#output\_autoscaling\_target\_resource\_id) | The resource ID of the autoscaling target |
| <a name="output_emergency_alarm_arn"></a> [emergency\_alarm\_arn](#output\_emergency\_alarm\_arn) | The ARN of the emergency scale up alarm |
| <a name="output_emergency_alarm_name"></a> [emergency\_alarm\_name](#output\_emergency\_alarm\_name) | The name of the emergency scale up alarm |
| <a name="output_emergency_scale_up_policy_arn"></a> [emergency\_scale\_up\_policy\_arn](#output\_emergency\_scale\_up\_policy\_arn) | The ARN of the emergency scale up policy |
| <a name="output_idle_scale_down_alarm_arn"></a> [idle\_scale\_down\_alarm\_arn](#output\_idle\_scale\_down\_alarm\_arn) | The ARN of the idle scale down alarm |
| <a name="output_idle_scale_down_alarm_name"></a> [idle\_scale\_down\_alarm\_name](#output\_idle\_scale\_down\_alarm\_name) | The name of the idle scale down alarm |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | The ARN of the SQS queue |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | The URL of the SQS queue |
| <a name="output_scale_down_policy_arn"></a> [scale\_down\_policy\_arn](#output\_scale\_down\_policy\_arn) | The ARN of the scale down policy |
| <a name="output_scale_up_policy_arn"></a> [scale\_up\_policy\_arn](#output\_scale\_up\_policy\_arn) | The ARN of the scale up policy |
<!-- END_TF_DOCS -->
