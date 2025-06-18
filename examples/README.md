# Examples

This directory contains examples showing different ways to use the ECS Auto Scaling module.

## Available Examples

### [Basic](./basic/)

A simple example showing the minimal configuration required to use the module with an existing ECS service and SQS queue.

**Best for:**

- Getting started quickly
- Simple proof of concept
- Basic auto scaling requirements

### [Advanced](./advanced/)

A more complex example showing advanced configuration with multiple services, custom thresholds, and different scaling strategies.

**Best for:**

- Production environments
- Multiple priority levels
- Custom scaling requirements
- Performance optimization

### [Complete](./complete/)

A comprehensive example that creates the entire infrastructure including VPC, ECS cluster, SQS queues, and auto scaling.

**Best for:**

- Complete infrastructure setup
- Learning the full architecture
- Production-ready deployments
- Understanding all components

## Usage

Each example includes:

- `README.md` - Detailed explanation and usage instructions
- `main.tf` - Main Terraform configuration
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `terraform.tfvars.example` - Example variable values

To use any example:

1. Navigate to the example directory
2. Copy `terraform.tfvars.example` to `terraform.tfvars`
3. Update the variables with your actual values
4. Run:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Prerequisites

Before running any example, ensure you have:

1. **AWS CLI configured** with appropriate permissions
2. **Terraform installed** (>= 1.0)
3. **AWS resources** (for basic/advanced examples):
   - Existing ECS cluster
   - Existing ECS service
   - Existing SQS queue

The complete example creates all necessary resources, so no prerequisites are needed beyond AWS access.

## Cost Considerations

- **Basic Example**: Minimal additional costs (mainly CloudWatch alarms)
- **Advanced Example**: Multiple alarm costs, proportional to number of services
- **Complete Example**: Full infrastructure costs including VPC, NAT Gateway, and ECS tasks

## Getting Help

If you encounter issues with any example:

1. Check the example's README for specific instructions
2. Verify your `terraform.tfvars` values are correct
3. Ensure you have the necessary AWS permissions
4. Review the main module documentation in the root README
