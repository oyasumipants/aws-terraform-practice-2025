output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.network.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.network.private_subnet_ids
}

output "isolated_subnet_ids" {
  description = "List of IDs of isolated subnets"
  value       = module.network.isolated_subnet_ids
}

output "default_security_group_id" {
  description = "The ID of the default security group"
  value       = module.network.default_security_group_id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.network.private_route_table_ids
}