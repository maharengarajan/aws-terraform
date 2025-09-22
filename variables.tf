variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
}

variable "project_name" {
  description = "The name of the project."
  type        = string  
}

variable "instance_type" {
  description = "The type of EC2 instance to use."
  type        = string
  default     = "t3.micro"  
}

variable "key_pair_name" {
  description = "The name of the key pair to use for EC2 instances."
  type        = string  
}