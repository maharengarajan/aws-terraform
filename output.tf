output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id  
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "availability_zones" {
  description = "The availability zones used"
  value       = data.aws_availability_zones.available.names  
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.shared.bucket 
}

output "iam_instance_profile" {
    description = "The name of the IAM instance profile"
    value       = aws_iam_instance_profile.ec2_instance_profile.name  
}