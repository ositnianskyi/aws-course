output "private_instance_private_ip" {
  description = "Private IP address of the EC2 private instance"
  value       = module.ec2.private_instance_private_ip
}

output "lb_dns_name" {
  description = "DNS name of load balancer"
  value = module.ec2.lb_dns_name
}

output "rds" {
  description = "RDS host"
  value = module.rds.rds_endpoint
}

output "sqs" {
  description = "SQS URL"
  value       = module.messaging.sqs
}

output "sns" {
  description = "SNS ARN"
  value       =  module.messaging.sns
}