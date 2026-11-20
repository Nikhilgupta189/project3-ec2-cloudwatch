
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Latest Amazon Linux 2023 AMI
data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}
# Use existing default VPC and subnet
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# EC2 Instance
resource "aws_instance" "monitor" {
  ami           = data.aws_ssm_parameter.amazon_linux.value
  instance_type = "t3.micro"

  subnet_id                   = data.aws_subnets.default.ids[0]
  associate_public_ip_address = false

  monitoring = true

  # Automatically generate CPU load for 10 minutes
  user_data = <<-EOF
    #!/bin/bash
    sleep 60
    timeout 600 bash -c 'yes > /dev/null & yes > /dev/null & wait'
  EOF

  tags = {
    Name = "project3-monitor-ec2"
  }
}

# CloudWatch CPU Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "project3-high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Alarm when EC2 CPU exceeds 30 percent"

  dimensions = {
    InstanceId = aws_instance.monitor.id
  }

  tags = {
    Project = "Project3"
  }
}

output "instance_id" {
  value = aws_instance.monitor.id
}

output "alarm_name" {
  value = aws_cloudwatch_metric_alarm.cpu_alarm.alarm_name
}
