resource "aws_instance" "NAT" {
  ami           = var.NatAMI
  instance_type = var.InstanceType
  key_name      = var.KeyName
  vpc_security_group_ids = [aws_security_group.Ec2SecurityGroupSsh.id, aws_security_group.Ec2SecurityGroupHttp.id]
  subnet_id = var.public_subnet_1_id
  source_dest_check = false

  tags = {
    Name = "NAT"
  }
}

resource "aws_instance" "Ec2InstancePrivate" {
  ami           = var.ImageAMI
  instance_type = var.InstanceType
  key_name      = var.KeyName
  vpc_security_group_ids = [aws_security_group.PrivateEc2SecurityGroup.id]
  subnet_id = var.private_subnet_1_id
  iam_instance_profile = aws_iam_instance_profile.PrivateInstanceProfile.name
  user_data            = data.template_file.init_ec2_private.rendered

  tags = {
    Name = "Ec2InstancePrivate"
  }
}

resource "aws_launch_template" "Ec2LaunchTemplate" {
  name          = "Ec2LaunchTemplate"
  image_id      = var.ImageAMI
  instance_type = var.InstanceType
  key_name      = var.KeyName
  vpc_security_group_ids = [aws_security_group.Ec2SecurityGroupSsh.id, aws_security_group.Ec2SecurityGroupHttp.id]
  user_data            = base64encode(data.template_file.init_ec2_public.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.PublicInstanceProfile.name
  }

  tags = {
    Name = "Ec2InstancePublic"
  }
}

resource "aws_autoscaling_group" "BasicAutoScalingGroup" {
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  vpc_zone_identifier = [var.public_subnet_1_id, var.public_subnet_2_id]
  health_check_type    = "ELB"
  load_balancers = [
    aws_elb.web_elb.id
  ]

  launch_template {
    id      = aws_launch_template.Ec2LaunchTemplate.id
    version = "$Latest"
  }
}

data "template_file" "init_ec2_public" {
  template = "${file("ec2/init_public_ec2.sh")}"
}

data "template_file" "init_ec2_private" {
  template = "${file("ec2/init_private_ec2.sh")}"

  vars = {
    rds_host = "${var.rds_url}"
  }
}