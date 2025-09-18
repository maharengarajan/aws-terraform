# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }  
}

# Private Subnets
resource "aws_subnet" "private" {
    count                  = length(var.private_subnet_cidrs)
    vpc_id                 = aws_vpc.main.id
    cidr_block             = var.private_subnet_cidrs[count.index]
    availability_zone      = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name        = "${var.project_name}-${var.environment}-private-subnet-${count.index + 1}"
        Environment = var.environment
        Project     = var.project_name
    }
}

# Route table for private subnets
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name        = "${var.project_name}-${var.environment}-private-rt"
        Environment = var.environment
        Project     = var.project_name
    }
}

# Associate private subnets with the route table
resource "aws_route_table_association" "private" {
    count          = length(aws_subnet.private)
    subnet_id      = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}

# S3 VPC Endpoint (Gateway Endpoint - Not Internet required)
resource "aws_vpc_endpoint" "s3" {
    vpc_id            = aws_vpc.main.id
    service_name      = "com.amazonaws.${var.aws_region}.s3"
    vpc_endpoint_type = "Gateway"
    route_table_ids   = [aws_route_table.private.id]

    tags = {
        Name        = "${var.project_name}-${var.environment}-s3-endpoint"
        Environment = var.environment
        Project     = var.project_name
    }  
}

# security group for EC2 instances
resource "aws_security_group" "ec2_sg" {
    vpc_id = aws_vpc.main.id
    name   = "${var.project_name}-${var.environment}-ec2-sg"
    description = "Security group for EC2 instances"

    # Allw outbound HTTPS for s3 and cloudwatch
    egress {
        from_port   = 443    # 443 for s3 and other AWS services
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow outbound HTTP for updates and other services
    egress {
        from_port   = 80   # 80 for HTTP traffic internet access
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name        = "${var.project_name}-${var.environment}-ec2-sg"
        Environment = var.environment
        Project     = var.project_name
    }
}