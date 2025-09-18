variable "aws_region" {
    description = "AWS region"
    type        = string
    default     = "us-east-1"
}

variable "project_name" {
    description = "Project name"
    type        = string
    default     = "aws-terraform-project"
}

variable "environment" {
    description = "Environment name"
    type        = string
    default     = "dev"
}

variable "vpc_cidr" {
    description = "VPC CIDR block"
    type        = string
    default     = "10.0.0.0/16"  # VPC has 65,536 private IPs to allocate
}

variable "private_subnet_cidrs" {
    description = "List of private subnet CIDR blocks"
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24"]  # Each /24 subnet has 256 IPs
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t3.micro"  
}

