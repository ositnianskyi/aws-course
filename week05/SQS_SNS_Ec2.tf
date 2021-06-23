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

resource "aws_instance" "Ec2Instance" {
  ami           = var.ImageAMI
  instance_type = var.InstanceType
  key_name      = var.KeyName
  security_groups = [aws_security_group.Ec2SecurityGroupSsh.name]
  iam_instance_profile = aws_iam_instance_profile.SqsSnsEC2Profile.name

  tags = {
    Name = "Ec2Instance"
  }
}

resource "aws_sqs_queue" "sqs-example" {
  name                      = "sqs-example"
  receive_wait_time_seconds = 5
}

resource "aws_sns_topic" "sns-example" {
  name = "sns-example-topic"
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

resource "aws_iam_instance_profile" "SqsSnsEC2Profile" {
  name = "SqsSnsEC2Profile"
  role = aws_iam_role.SqsSnsEC2Role.name
}

resource "aws_iam_role" "SqsSnsEC2Role" {
  name = "SqsSnsEC2Role"
  assume_role_policy = data.aws_iam_policy_document.ec2-role-policy-document.json
}

resource "aws_iam_role_policy" "SqsSnsEC2RolePolicy" {
  name = "SqsSnsEC2RolePolicy"
  role = aws_iam_role.SqsSnsEC2Role.id
  policy = data.aws_iam_policy_document.sqs-sns-policy-document.json
}

data "aws_iam_policy_document" "ec2-role-policy-document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "sqs-sns-policy-document" {
  statement {
    actions = ["sns:*"]
    resources = ["*"]
  }

  statement {
    actions = ["sqs:*"]
    resources = ["*"]
  }
}