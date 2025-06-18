# Basic ECS Auto Scaling Example

This example shows the basic usage of the ECS auto scaling module with minimal configuration.

## Usage

1. Update the variables in `terraform.tfvars` with your actual values
2. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

## Prerequisites

- Existing ECS cluster
- Existing ECS service
- Existing SQS queue

## What this creates

- Auto scaling target for your ECS service
- CloudWatch alarms for scaling triggers
- Auto scaling policies for scale up/down operations

## Configuration

The example uses default thresholds which work well for most use cases:

- Scale up when messages are older than 3 minutes
- Emergency scale up when messages are older than 4 minutes
- Scale down when queue has fewer than 10 visible messages and oldest message is less than 30 seconds old
