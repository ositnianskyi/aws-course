variable "RDS_username" {
  description = "username"
  type        = string
  default     = "rootuser"
}

variable "RDS_password" {
  description = "password"
  type        = string
  default     = "rootuser"
}

variable "private_subnet_1_id" {
  type        = string
}

variable "private_subnet_2_id" {
  type        = string
}

variable "VPC_id" {
  type        = string
}

variable "db_name" {
  type = string
  default = "rootuser"
}