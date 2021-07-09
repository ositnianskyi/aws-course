resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups    = [aws_security_group.Ec2SecurityGroupHttp.id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]
  cross_zone_load_balancing   = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/actuator/health"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }

}