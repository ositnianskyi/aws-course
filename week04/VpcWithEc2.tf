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

resource "aws_vpc" "aws_cource_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "aws_cource_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.aws_cource_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.aws_cource_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-west-2b"

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.aws_cource_vpc.id
}

resource "aws_route_table" "private_routes" {
  vpc_id = aws_vpc.aws_cource_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = aws_instance.NAT.id
  }
}

resource "aws_route_table" "public_routes" {
  vpc_id = aws_vpc.aws_cource_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_rt" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_routes.id
}

resource "aws_route_table_association" "private_rt" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_routes.id
}

resource "aws_instance" "Ec2InstancePublic" {
  ami           = var.ImageAMI
  instance_type = var.InstanceType
  key_name      = var.KeyName
  vpc_security_group_ids = [aws_security_group.Ec2SecurityGroupSsh.id,
  aws_security_group.Ec2SecurityGroupHttp.id]
  subnet_id = aws_subnet.public_subnet.id
  user_data            = data.template_file.init_ec2_public.rendered

  tags = {
    Name = "Ec2InstancePublic"
  }
}

resource "aws_instance" "Ec2InstancePrivate" {
  ami           = var.ImageAMI
  instance_type = var.InstanceType
  key_name      = var.KeyName
  vpc_security_group_ids = [aws_security_group.PrivateEc2SecurityGroup.id]
  subnet_id = aws_subnet.private_subnet.id
  user_data            = data.template_file.init_ec2_private.rendered

  tags = {
    Name = "Ec2InstancePrivate"
  }
}

resource "aws_instance" "NAT" {
  ami           = var.NatAMI
  instance_type = var.InstanceType
  key_name      = var.KeyName
  vpc_security_group_ids = [aws_security_group.Ec2SecurityGroupSsh.id, aws_security_group.Ec2SecurityGroupHttp.id]
  subnet_id = aws_subnet.public_subnet.id
  source_dest_check = false

  tags = {
    Name = "NAT"
  }
}

resource "aws_lb" "alb" {
  name               = "alb-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Ec2SecurityGroupHttp.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
}

resource "aws_lb_listener" "cource_demo" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lbTargetGroup.arn
  }
}

resource "aws_lb_target_group" "lbTargetGroup" {
  name     = "lbTargetGroup"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.aws_cource_vpc.id
}

resource "aws_lb_target_group_attachment" "Ec2Public" {
  target_group_arn = aws_lb_target_group.lbTargetGroup.arn
  target_id        = aws_instance.Ec2InstancePublic.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "Ec2Private" {
  target_group_arn = aws_lb_target_group.lbTargetGroup.arn
  target_id        = aws_instance.Ec2InstancePrivate.id
  port             = 80
}

resource "aws_security_group" "Ec2SecurityGroupSsh" {
  name        = "Ec2SecurityGroupSsh"
  description = "Security group for ssh access"
  vpc_id = aws_vpc.aws_cource_vpc.id

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

resource "aws_security_group" "PrivateEc2SecurityGroup" {
  name        = "PrivateEc2SecurityGroup"
  description = "Security group for ssh access"
  vpc_id = aws_vpc.aws_cource_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    from_port   = 433
    to_port     = 433
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
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
  vpc_id = aws_vpc.aws_cource_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

data "template_file" "init_ec2_public" {
  template = "${file("init_ec2.sh")}"

  vars = {
    env = "public"
  }
}

data "template_file" "init_ec2_private" {
  template = "${file("init_ec2.sh")}"

  vars = {
    env = "private"
  }
}