resource "aws_sqs_queue" "sqs" {
  name                      = var.sqs_topic
  receive_wait_time_seconds = 15
}

resource "aws_sns_topic" "sns" {
  name = var.sns_topic
}