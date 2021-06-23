# Week 05
### Task
- Create a Terraform script which will create the next infrastructure:
1. SQS queue
2. SNS topic
3. EC2 instance with access to SQS and SNS services and SSH access to the instance as ususal
4. Output EC2 ip, topic ARN and queue URL
- Terraform not supports email notification (see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#email). So due to this when your infrastructure is deployed, you need to login in AWS management console and create manually email subscription to the created topic (do not forget to confirm it)
- SSH to the created EC2 instance
- Send and receive messages to/from SQS using AWS CLI commands
- Send messages to SNS and get email notification using AWS CLI commands

### Solution
- `cd week05`
- `terraform init`
- `terraform apply`
  `Outputs:
public_instance_public_ip = "52.37.137.237"
sns = "arn:aws:sns:us-west-2:260717713138:sns-example-topic"
sqs = "https://sqs.us-west-2.amazonaws.com/260717713138/sqs-example"
`
- Ssh to ec2 instance: `ssh -i /Users/ositnianskyi/AWS-course/os_admin_key_us2.pem ec2-user@52.37.137.237`
- Subscribe email to SNS topic via AWS console UI.
- Puplish notification to SNS: `aws sns publish --region us-west-2 --topic-arn 'arn:aws:sns:us-west-2:260717713138:sns-example-topic' --message 'Hello SNS world!'
  {
  "MessageId": "e08be534-6b51-51a5-b594-bc79035fb02f"
  }
  `
- Send message to SQS: `aws sqs send-message --region us-west-2 --queue-url https://sqs.us-west-2.amazonaws.com/260717713138/sqs-example --message-body 'Hello SQS world!'`
  `{
  "MD5OfMessageBody": "77c735b29c429695e172030fdf1c8b92",
  "MessageId": "933ee884-3635-4fb9-839d-6b389e265e9a"
  }`
- Receive message from SQS: `aws sqs receive-message --region us-west-2 --queue-url https://sqs.us-west-2.amazonaws.com/260717713138/sqs-example`
  `{
  "Messages": [
  {
  "Body": "Hello SQS world!",
  "ReceiptHandle": "AQEBbs1pw64u/gWCA8/T16Hb2vdMLCpucKWM0XMDhSlAIKNmq9BJqr6BYedYyjaLp/YWiIuQ1GP04PKYxQv/j+HGsk2HOqBzcOCLmW2wW7G48miPbUCJryhw8b36G+cQ/JV7v96sYn1+8wnPTy3JaKcHBy8yR0SaV5NyY7GmCh+wRmWLj7faiVy4+9YqXNOM4sGmqOG43fuZL6hx99p6iiPuOBox3EvAct0VYImltYnlqy28eRcClxGh67RgAFHKlYrVizFyfPbnB6MLLNMhB2QE7cmSWDVsNsp8tN5CHao6Zr4RS/2EdA7PUcKfMp6b8n5NEVJaO27XqXHea37fyLV4PmYHnSXjhMiMFc7KVUyCjX6QJe0Vx0IYgVjr8a3g0drZw9yfH0jplZWgCOCMYYAbcg==",
  "MD5OfBody": "77c735b29c429695e172030fdf1c8b92",
  "MessageId": "933ee884-3635-4fb9-839d-6b389e265e9a"
  }
  ]
  }`
- `terraform destroy`