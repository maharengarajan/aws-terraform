# Main s3 for file storage
resource "aws_s3_bucket" "project_bucket" {
    bucket = "${var.project_name}-${var.environment}-bucket"

    tags = {
        Name        = "${var.project_name}-${var.environment}-bucket"
        Environment = var.environment
        Project     = var.project_name
    }
}

# cloudtrail s3 bucket
resource "aws_s3_bucket" "cloudtrail_bucket" {
    bucket = "${var.project_name}-${var.environment}-cloudtrail-bucket"

    tags = {
        Name        = "${var.project_name}-${var.environment}-cloudtrail-bucket"
        Environment = var.environment
        Project     = var.project_name
    }
}

# Block public access for the s3 bucket (project bucket)
resource "aws_s3_bucket_public_access_block" "block_public_access" {
    bucket = aws_s3_bucket.project_bucket.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

# Block public access for s3 buckets and cloudtrail
resource "aws_s3_bucket_public_access_block" "cloudtrail_block_public_access" {
    bucket = aws_s3_bucket.cloudtrail_bucket.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

# Lifecycle policy for cost optimization
resource "aws_s3_bucket_lifecycle_configuration" "project_bucket_lifecycle" {
    bucket = aws_s3_bucket.project_bucket.id

    rule {
        id = "Transition to STANDARD_IA after 30 days"
        status = "Enabled"

        transition {
            days = 30
            storage_class = "STANDARD_IA"
        }

        transition {
            days = 90
            storage_class = "GLACIER"
        }
    }
}

# cloudtrail s3 bucket policy
resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
    bucket = aws_s3_bucket.cloudtrail_bucket.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "AWSCloudTrailAclCheck"
                Effect = "Allow"
                Principal = {
                    Service = "cloudtrail.amazonaws.com"
                }
                Action = "s3:GetBucketAcl"
                Resource = "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.id}"
            },
            {
                Sid = "AWSCloudTrailWrite"
                Effect = "Allow"
                Principal = {
                    Service = "cloudtrail.amazonaws.com"
                }
                Action = "s3:PutObject"
                Resource = "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
                Condition = {
                    StringEquals = {
                        "s3:x-amz-acl" = "bucket-owner-full-control"
                    }
                }
            }
        ]
    })
}