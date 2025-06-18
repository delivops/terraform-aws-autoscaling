# Advanced ECS Auto Scaling Example

This example demonstrates advanced configuration options with custom thresholds and multiple scaling scenarios.

## Features

- Custom scaling thresholds optimized for high-throughput processing
- Faster emergency response times
- More aggressive scale-down criteria for cost optimization
- Multiple queue support (shows pattern for multiple services)

## Usage

1. Update the variables in `terraform.tfvars` with your actual values
2. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

## Advanced Configuration

This example uses more aggressive scaling parameters:

- Faster scale up: 2 minutes instead of 3
- Faster emergency response: 3 minutes instead of 4
- More aggressive scale down: only 5 visible messages threshold
- Shorter cooldown periods for faster response

## Use Cases

This configuration works well for:

- High-throughput message processing
- Time-sensitive workloads
- Environments where cost optimization is important
- Services with predictable traffic patterns
