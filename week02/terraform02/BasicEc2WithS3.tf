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
  security_groups = [aws_security_group.Ec2SecurityGroupSsh.name,
  aws_security_group.Ec2SecurityGroupHttp.name]
  iam_instance_profile = aws_iam_instance_profile.S3InstanceProfile.name
  user_data            = data.template_file.get_s3_file.rendered
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

resource "aws_iam_instance_profile" "S3InstanceProfile" {
  name = "S3InstanceProfile"
  role = aws_iam_role.S3GetRole.name
}

resource "aws_iam_role" "S3GetRole" {
  name = "S3GetRoleName"
  assume_role_policy = data.aws_iam_policy_document.ec2-role-policy-document.json
}

resource "aws_iam_role_policy" "s3_role_policy" {
  name = "s3_role_policy"
  role = aws_iam_role.S3GetRole.id
  policy = data.aws_iam_policy_document.s3-policy-document.json
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

data "aws_iam_policy_document" "s3-policy-document" {
  statement {
    actions = ["s3:GetObject"]
    resources = ["*"]
  }
}

data "template_file" "get_s3_file" {
  template = "${file("get_s3_file.sh")}"

  vars = {
    uri = var.S3FileURI
  }
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.Ec2Instance.public_ip
}
