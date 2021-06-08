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
  user_data            = data.template_file.init_ec2.rendered
}

resource "aws_db_instance" "rds_db" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "9.6"
  instance_class       = "db.t2.micro"
  name                 = "rdsDatabase"
  username             = var.RDS_username
  password             = var.RDS_password
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db_group.id]
}

resource "aws_dynamodb_table" "dynamodb_db" {
  name             = var.DynamoDB_table_name
  hash_key         = "id"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "id"
    type = "N"
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

resource "aws_security_group" "db_group" {
  name        = "db_group"
  description = "Enable ingress access to db"

  ingress {
    from_port   = 5432
    to_port     = 5432
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
  role = aws_iam_role.DBforEC2Role.name
}

resource "aws_iam_role" "DBforEC2Role" {
  name = "DBforEC2Role"
  assume_role_policy = data.aws_iam_policy_document.ec2-role-policy-document.json
}

resource "aws_iam_role_policy" "db_role_policy" {
  name = "db_role_policy"
  role = aws_iam_role.DBforEC2Role.id
  policy = data.aws_iam_policy_document.db-policy-document.json
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

data "aws_iam_policy_document" "db-policy-document" {
  statement {
    actions = ["s3:*"]
    resources = ["*"]
  }

  statement {
    actions = ["dynamodb:*"]
    resources = ["*"]
  }
}

data "template_file" "init_ec2" {
  template = "${file("init_ec2.sh")}"

  vars = {
    uri = var.S3FilesURI
  }
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.Ec2Instance.public_ip
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.rds_db.endpoint
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.rds_db.port
}
