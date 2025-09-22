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