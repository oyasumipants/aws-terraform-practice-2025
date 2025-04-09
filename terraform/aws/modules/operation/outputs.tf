output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.operation.id
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.operation.private_ip
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.operation.arn
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.instance.id
}

output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.ssm_role.arn
}

output "instance_profile_arn" {
  description = "ARN of the IAM instance profile"
  value       = aws_iam_instance_profile.ssm_instance_profile.arn
}

output "scripts_bucket_name" {
  description = "Name of the S3 bucket for operation scripts"
  value       = aws_s3_bucket.scripts_bucket.id
}

output "scripts_bucket_arn" {
  description = "ARN of the S3 bucket for operation scripts"
  value       = aws_s3_bucket.scripts_bucket.arn
}
