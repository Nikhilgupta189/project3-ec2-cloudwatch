# Project 3: EC2 CPU Monitoring with CloudWatch Alarm

## Objective
Deploy an EC2 instance using Terraform and monitor CPU utilization using AWS CloudWatch.

## Technologies Used
- AWS EC2
- Amazon CloudWatch
- Terraform
- AWS CLI

## Implementation
1. Created EC2 instance using Terraform.
2. Enabled detailed CloudWatch monitoring.
3. Configured a CPU alarm with a 30% threshold.
4. Automatically generated CPU load using EC2 user data.
5. Verified CloudWatch alarm triggering.
6. Captured CloudWatch alarm screenshot.
7. Destroyed AWS resources using Terraform.

## Alarm Configuration
- Metric: CPUUtilization
- Threshold: 30%
- Evaluation Period: 60 seconds
- AWS Region: ap-south-1
- Instance Type: t3.micro

## Terraform Commands
- terraform init
- terraform validate
- terraform plan
- terraform apply
- terraform destroy

## Screenshot
![CloudWatch Alarm](screenshots/cloudwatch-alarm.png)

## Result
Successfully deployed EC2 monitoring with Terraform and tested CPU spike detection using CloudWatch.

## Cleanup
All AWS resources were deleted using terraform destroy.
