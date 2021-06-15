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

variable "NatAMI" {
  description = "Name of an existing NAT AMI image."
  type        = string
  default     = "ami-0032ea5ae08aa27a2"
}