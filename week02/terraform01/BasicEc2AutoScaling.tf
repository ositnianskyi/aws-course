terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_launch_template" "Ec2LaunchTemplate" {
  name          = "Ec2LaunchTemplate"
  image_id      = var.ImageAMI
  instance_type = var.InstanceType
  key_name      = var.KeyName
  security_group_names = [aws_security_group.Ec2SecurityGroupSsh.name,
  aws_security_group.Ec2SecurityGroupHttp.name]
  user_data = filebase64("install_java.sh")
}

resource "aws_autoscaling_group" "BasicAutoScalingGroup" {
  availability_zones = [var.AvailabilityZone]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2

  launch_template {
    id      = aws_launch_template.Ec2LaunchTemplate.id
    version = "$Latest"
  }
}

resource "aws_security_group" "Ec2SecurityGroupSsh" {
  name        = "Ec2SecurityGroupSsh"
  description = "Security group for ssh access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Ec2SecurityGroupHttp" {
  name        = "Ec2SecurityGroupHttp"
  description = "Enable HTTP access via user defined port"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
