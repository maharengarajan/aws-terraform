output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.main.id  
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.project_bucket.bucket  
}

output "cloudtrail_bucket_name" {
  description = "The name of the CloudTrail S3 bucket"
  value       = aws_s3_bucket.cloudtrail_bucket.bucket  
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.main.id  
}