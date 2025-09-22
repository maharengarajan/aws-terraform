# S3 bucket for shared storage
resource "aws_s3_bucket" "shared" {
  bucket = "${var.project_name}-shared-bucket-${random_string.bucket_suffix.result}"

  tags = {
    Name = "${var.project_name}-shared-bucket"
  }
}

# Random suffix for bucket name uniqueness
resource "random_string" "bucket_suffix" {
  length  = 6
  upper   = false
  special = false
}

# S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "shared" {
  bucket = aws_s3_bucket.shared.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}