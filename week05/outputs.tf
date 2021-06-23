output "public_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.Ec2Instance.public_ip
}

output "sqs" {
  description = "SQS URL"
  value       = aws_sqs_queue.sqs-example.id
}

output "sns" {
  description = "SNS ARN"
  value       = aws_sns_topic.sns-example.arn
}