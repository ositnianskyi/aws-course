output "public_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.Ec2InstancePublic.public_ip
}

output "private_instance_private_ip" {
  description = "Private IP address of the EC2 private instance"
  value       = aws_instance.Ec2InstancePrivate.private_ip
}

output "lb_dns_name" {
  description = "DNS name of load balancer"
  value       = aws_lb.alb.dns_name
}