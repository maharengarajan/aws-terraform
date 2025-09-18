# EC2 instance Role
resource "aws_iam_role" "ec2_role" {
    name = "${var.project_name}-${var.environment}-ec2-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })

    tags = {
        Name        = "${var.project_name}-${var.environment}-ec2-role"
        Project     = var.project_name
        Environment = var.environment
    }
}

# S3 access policy for EC2 instance
resource "aws_iam_policy" "ec2_s3_access_policy" {
    name = "${var.project_name}-${var.environment}-s3-access-policy"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "s3:GetObject",
                    "s3:ListBucket"
                ]
                Effect   = "Allow"
                Resource = [
                    aws_s3_bucket.project_bucket.arn,
                    "${aws_s3_bucket.project_bucket.arn}/*"
                ]
            }
        ]
    })
}

# cloudwatch policy for ec2
resource "aws_iam_policy" "ec2_cloudwatch_policy" {
    name = "${var.project_name}-${var.environment}-cloudwatch-policy"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Effect   = "Allow"
                Resource = "arn:aws:logs:*:*:*"
            }
        ]
    })
}

# Attach policies to the EC2 role
resource "aws_iam_role_policy_attachment" "ec2_s3_access_attachment" {
    role       = aws_iam_role.ec2_role.name
    policy_arn = aws_iam_policy.ec2_s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_attachment" {
    role       = aws_iam_role.ec2_role.name
    policy_arn = aws_iam_policy.ec2_cloudwatch_policy.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attachment" {
    role       = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  
}

# Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
    name = "${var.project_name}-${var.environment}-ec2-instance-profile"
    role = aws_iam_role.ec2_role.name
}

# CloudTrail Role
resource "aws_iam_role" "cloudtrail_role" {
    name = "${var.project_name}-${var.environment}-cloudtrail-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "cloudtrail.amazonaws.com"
                }
            }
        ]
    })

    tags = {
        Name        = "${var.project_name}-${var.environment}-cloudtrail-role"
        Project     = var.project_name
        Environment = var.environment
    }
}

# CloudTrail Policy
resource "aws_iam_policy" "cloudtrail_policy" {
    name = "${var.project_name}-${var.environment}-cloudtrail-policy"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "s3:PutObject",
                    "s3:GetBucketAcl"
                ]
                Effect   = "Allow"
                Resource = [
                    aws_s3_bucket.project_bucket.arn,
                    "${aws_s3_bucket.project_bucket.arn}/*"
                ]
            }
        ]
    })
}
     