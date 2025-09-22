terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
  }
    required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

# Data source to get availability zones
data "aws_availability_zones" "available" {
    state = "available"
}