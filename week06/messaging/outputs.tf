output "sqs" {
  description = "SQS URL"
  value       = aws_sqs_queue.sqs.id
}

output "sns" {
  description = "SNS ARN"
  value       = aws_sns_topic.sns.arn
}