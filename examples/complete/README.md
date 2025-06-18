# Complete Infrastructure Example

This example creates a complete infrastructure setup including:

- VPC with public/private subnets
- ECS cluster with Fargate capacity providers
- SQS queue with dead letter queue
- ECS service with auto scaling
- CloudWatch dashboard for monitoring

## Architecture

```
Internet Gateway
    │
    └── Public Subnets (2 AZs)
         │
         └── NAT Gateways
              │
              └── Private Subnets (2 AZs)
                   │
                   ├── ECS Fargate Tasks
                   └── VPC Endpoints (optional)
```

## Components

1. **VPC Infrastructure**

   - VPC with public and private subnets across 2 AZs
   - Internet Gateway and NAT Gateways
   - Route tables and security groups

2. **ECS Infrastructure**

   - ECS cluster with Fargate capacity providers
   - Task definition for message processing
   - ECS service with desired count

3. **SQS Infrastructure**

   - Main processing queue
   - Dead letter queue for failed messages
   - Queue policies and encryption

4. **Auto Scaling**

   - Complete auto scaling setup using this module
   - CloudWatch alarms and scaling policies

5. **Monitoring**
   - CloudWatch dashboard
   - Custom metrics and alarms

## Usage

1. Update the variables in `terraform.tfvars`
2. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

## Customization

You can customize this example by:

- Modifying the VPC CIDR blocks
- Changing the ECS task definition
- Adjusting scaling parameters
- Adding additional monitoring

## Cost Considerations

This example creates several AWS resources that incur costs:

- NAT Gateways (primary cost driver)
- ECS Fargate tasks
- CloudWatch alarms and dashboards
- SQS message processing

Consider using VPC endpoints to reduce NAT Gateway costs for production workloads.
