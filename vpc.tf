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