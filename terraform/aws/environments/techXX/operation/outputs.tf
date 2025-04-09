output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.operation.instance_id
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.operation.instance_private_ip
}

output "ssm_connection_command" {
  description = "Command to connect to the instance using SSM"
  value       = "aws ssm start-session --target ${module.operation.instance_id}"
}
