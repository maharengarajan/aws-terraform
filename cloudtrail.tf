# Cloudtrail for activity logging
resource "aws_cloudtrail" "main" {
    name                  = "${var.project_name}-${var.environment}-cloudtrail"
    s3_bucket_name        = aws_s3_bucket.cloudtrail_bucket.bucket

    event_selector {
        read_write_type           = "All"
        include_management_events = true
        exclude_management_event_sources = []

        data_resource {
            type   = "AWS::S3::Object"
            values = ["${aws_s3_bucket.project_bucket.arn}/*"]
        }
    }

    depends_on = [aws_s3_bucket_policy.cloudtrail_bucket_policy]

    tags = {
        Name        = "${var.project_name}-${var.environment}-cloudtrail"
        Environment = var.environment
        Project     = var.project_name
    }
}