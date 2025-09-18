# Get latest amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners       = ["amazon"]
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

# EC2 Instance
resource "aws_instance" "main" {
    ami           = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type
    subnet_id     = aws_subnet.private[0].id
    vpc_security_group_ids = [aws_security_group.instance.id]
    iam_instance_profile =   aws_iam_instance_profile.ec2_instance_profile.name

    user_data =  base64encode(templatefile("${path.module}/scripts/user_data.sh", {
        bucket_name = aws_s3_bucket.project_bucket.bucket
    }))

    tags = {
        Name        = "${var.project_name}-${var.environment}-instance"
        Environment = var.environment
        Project     = var.project_name
    }
}

# Cloudwatch VPC endpoint for logs
resource "aws_vpc_endpoint" "cloudwatch" {
    vpc_id            = aws_vpc.main.id
    service_name      = "com.amazonaws.${var.aws_region}.logs"
    vpc_endpoint_type = "Interface"
    subnet_ids        = [aws_subnet.private[0].id]
    security_group_ids = [aws_security_group.instance.id]
    private_dns_enabled = true

    tags = {
        Name        = "${var.project_name}-${var.environment}-cloudwatch-endpoint"
        Environment = var.environment
        Project     = var.project_name
    }
}

# Security group for VPC endpoints
resource "aws_security_group" "instance" {
    vpc_id = aws_vpc.main.id
    name   = "${var.project_name}-${var.environment}-instance-sg"
    description = "Security group for EC2 instance and VPC endpoints"

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [var.vpc_cidr]
    }

    tags = {
        Name        = "${var.project_name}-${var.environment}-instance-sg"
        Environment = var.environment
        Project     = var.project_name
    }
}

