output "NAT_public_ip" {
  description = "Public IP address of the NAT instance"
  value       = aws_instance.NAT.public_ip
}

output "NAT_id" {
  value       = aws_instance.NAT.id
}

output "private_instance_private_ip" {
  description = "Private IP address of the EC2 private instance"
  value       = aws_instance.Ec2InstancePrivate.private_ip
}

output "lb_dns_name" {
  description = "DNS name of load balancer"
  value       = aws_elb.web_elb.dns_name
}