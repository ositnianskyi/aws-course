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
  ami             = var.ImageAMI
  instance_type   = var.InstanceType
  key_name        = var.KeyName
  security_groups = [aws_security_group.Ec2SecurityGroupSsh.name]

  tags = {
    Name = "Ec2Instance"
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

  tags = {
    Name = "Ec2SecurityGroupSsh"
  }
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.Ec2Instance.public_ip
}
