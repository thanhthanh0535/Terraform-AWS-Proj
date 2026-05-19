output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "s3_bucket_name" {
  description = "Name of the S3 app-assets bucket"
  value       = aws_s3_bucket.app_assets.bucket
}

output "web_sg_id" {
  description = "Security group ID for the web tier"
  value       = aws_security_group.web.id
}

output "app_sg_id" {
  description = "Security group ID for the app tier"
  value       = aws_security_group.app.id
}
