variable "InstanceType" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "KeyName" {
  description = "Name of an existing EC2 KeyPair to enable SSH access to the instance"
  type        = string
  default     = "os_admin_key_us2"
}

variable "ImageAMI" {
  description = "Name of an existing AMI image."
  type        = string
  default     = "ami-0cf6f5c8a62fa5da6"
}

variable "S3FilesURI" {
  description = "S3 URI for folder"
  type        = string
  default     = "s3://os-aws-cource-bucket-test/db_files/"
}

variable "RDS_username" {
  description = "username"
  type        = string
  default     = "postgres"
}

variable "RDS_password" {
  description = "password"
  type        = string
  default     = "pass_varfoobar"
}

variable "DynamoDB_table_name" {
  description = "DynamoDB_table_name"
  type        = string
  default     = "os-aws-cource-solar-system"
}