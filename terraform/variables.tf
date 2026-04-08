variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "YOUR PROJECT NAME"
}

variable "my_ip" {
  type        = string
  description = "YOUR PRIVATE IP"
}

variable "key_name" {
  type        = string
  description = "YOUR KEYNAME"
}

variable "custom_ami_id_awsl" {
  type        = string
  description = "YOUR AWSL AMI ID"
}

variable "custom_ami_id_ubuntu" {
  type        = string
  description = "YOUR UBUNTU AMI ID"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}
