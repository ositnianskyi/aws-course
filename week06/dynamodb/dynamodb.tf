resource "aws_dynamodb_table" "dynamodb_db" {
  name             = var.DynamoDB_table_name
  hash_key         = "UserName"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "UserName"
    type = "S"
  }
}